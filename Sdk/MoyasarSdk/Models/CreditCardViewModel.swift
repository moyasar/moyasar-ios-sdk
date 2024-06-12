import Foundation
import SwiftUI
import Combine

public class CreditCardViewModel: ObservableObject {
    let formatter = CreditCardFormatter()
    let expiryFormatter = ExpiryFormatter()
    let currencyUtil = CurrencyUtil()

    var paymentRequest: PaymentRequest
    var resultCallback: ResultCallback
    var currentPayment: ApiPayment? = nil
    var paymentService: PaymentService
    
    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.currencyCode = paymentRequest.currency
        return formatter
    }()
    
    @Published var status = CreditCardViewModelStatus.reset
    @Published var error: String? = nil
    @Published var nameOnCard = ""
    
    @Published var number = "" {
        didSet {
            let filtered = self.formatter.string(for: self.number)!
            if number != filtered {
                number = filtered
            }
        }
    }

    @Published var expiryDate = "" {
        didSet {
            let filtered = self.expiryFormatter.format(expiryDate)
            if expiryDate != filtered {
                expiryDate = filtered
            }
        }
    }
    
    @Published var securityCode = "" {
        didSet {
            var filtered = ArabicNumberMapper.mapArabicNumbers(securityCode)
            filtered = String(filtered.filter { $0.isNumber }.prefix(4))
            if securityCode != filtered {
                securityCode = filtered
            }
        }
    }
    
    var formattedAmount: String {
        let majorAmount = currencyUtil.toMajor(paymentRequest.amount, currency: paymentRequest.currency)
        let amount = numberFormatter.string(from: majorAmount as NSNumber)!
        return "pay".localized() + " \(amount)"
    }
    
    var isValid: Bool {
        let validations = [
            nameValidator.validate(value: nameOnCard),
            numberValidator.validate(value: number),
            expiryValidator.validate(value: expiryDate),
            securityCodeValidator.validate(value: securityCode)
        ]
        
        return validations.allSatisfy({ $0 == nil })
    }
    
     func shoudDisable() -> Bool {
        switch (status) {
        case .reset:
            return false
        default:
            return true
        }
    }

    var showAuth: Bool {
        if case .paymentAuth(_) = status {
            return true
        }
        return false
    }
    
    var authUrl: URL? {
        if case .paymentAuth(let url) = status {
            return URL(string: url)!
        }
        return nil
    }
    
    lazy var nameValidator = NameOnCardValidator()
    lazy var numberValidator = CardNumberValidator()
    lazy var expiryValidator = ExpiryValidator()
    lazy var securityCodeValidator = SecurityCodeValidator(getNumber: { self.number })
    
    public init(paymentRequest: PaymentRequest, resultCallback: @escaping ResultCallback) throws {
        self.paymentRequest = paymentRequest
        self.resultCallback = resultCallback
        self.paymentService = try PaymentService(apiKey: paymentRequest.apiKey)
    }
    
    func showNetworkLogo(_ network: CreditCardNetwork) -> Bool {
        let inferred = getCardNetwork(number)
        switch inferred {
        case .unknown:
            return true
        default:
            return inferred == network
        }
    }
    
    func beginTransaction() async {
        self.error = nil
        guard isValid else {
            return
        }
        
        guard let expiry = ExpiryDate.fromPattern(expiryDate) else {
            return
        }
        
        let source = ApiCreditCardSource(
            name: nameOnCard,
            number: number.filter { $0.isNumber },
            month: String(expiry.month),
            year: String(expiry.year),
            cvc: securityCode,
            manual: paymentRequest.manual ? "true" : "false",
            saveCard: paymentRequest.saveCard ? "true" : "false"
        )
        
        do {
            if (paymentRequest.createSaveOnlyToken) {
                try await beginSaveOnlyToken(source)
            } else {
                try await beginPayment(source)
            }
        } catch {
            handleError(error)
        }
    }
    
    func beginPayment(_ source: ApiCreditCardSource) async throws {
        status = .processing
        
        let request = ApiPaymentRequest(
            amount: paymentRequest.amount,
            currency: paymentRequest.currency,
            description: paymentRequest.description,
            callbackUrl: "https://sdk.moyasar.com/return",
            source: ApiPaymentSource.creditCard(source),
            metadata: paymentRequest.metadata.merging(["sdk": "ios"], uniquingKeysWith: {k, _ in k })
        )
        
        do {
            let payment = try await paymentService.createPayment(request)
            currentPayment = payment
            startPaymentAuthProcess()
        } catch {
            throw error
        }
    }
    
    func beginSaveOnlyToken(_ source: ApiCreditCardSource) async throws {
        status = .processing
        
        let request = ApiTokenRequest(
            name: source.name,
            number: source.number,
            cvc: source.cvc,
            month: source.month,
            year: source.year,
            saveOnly: true,
            callbackUrl: "https://sdk.moyasar.com/return",
            metadata: paymentRequest.metadata
        )
        
        do {
            let token = try await paymentService.createToken(request)
            resultCallback(.saveOnlyToken(token))
        } catch {
            throw error
        }
    }
    
    func startPaymentAuthProcess() {
        guard let payment = currentPayment else {
            handleError(MoyasarError.unexpectedError("Current payment is nil"))
            return
        }
        
        if (!payment.isInitiated()) {
            // Payment status could be paid, failed, authorized, etc...
            resultCallback(.completed(payment))
            return
        }
        
        // set status to paymentAuth and show webview
        guard case let .creditCard(source) = payment.source else {
            handleError(MoyasarError.unexpectedError("Initiated payment has invalid source type"))
            return
        }
        
        status = .paymentAuth(source.transactionUrl!)
    }
    
    func handleWebViewResult(_ result: WebViewResult) {
        switch result {
        case .completed(let info):
            self.currentPayment!.updateFromWebViewPaymentInfo(info)
            resultCallback(.completed(self.currentPayment!))
        case .failed(let error):
            switch error {
            case .timeOut:
                let callbackError = MoyasarError.webviewTimedOut(currentPayment!)
                resultCallback(.failed(callbackError))
            case .notConnectedToInternet:
                let callbackError = MoyasarError.webviewNotConnectedToInternet(currentPayment!)
                resultCallback(.failed(callbackError))
            case .unexpectedError(let webviewError):
                let callbackError = MoyasarError.webviewUnexpectedError(currentPayment!, webviewError)
                resultCallback(.failed(callbackError))
            }
            self.status = .reset
        }
    }
    
    func handleError(_ error: Error) {
        let callbackError = MoyasarError.unexpectedError("Credit Card payment request failed: \(error.localizedDescription)")
        resultCallback(.failed(callbackError))
    }
}

enum CreditCardViewModelStatus {
    case reset
    case processing
    case paymentAuth(String)
}

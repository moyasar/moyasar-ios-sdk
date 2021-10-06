import Foundation
import SwiftUI
import Combine

public class CreditCardViewModel: ObservableObject {
    let formatter = CreditCardFormatter()
    let expiryFormatter = ExpiryFormatter()
    var paymentService = PaymentService()
    let currencyUtil = CurrencyUtil()

    var paymentRequest: PaymentRequest
    var resultCallback: ResultCallback
    var currentPayment: ApiPayment? = nil
    
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
            let filtered = self.formatter.string(for: number)!
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
            let filtered = String(securityCode.filter { $0.isNumber }.prefix(4))
            if securityCode != filtered {
                securityCode = filtered
            }
        }
    }
    
    var formattedAmount: String {
        let majorAmount = currencyUtil.toMajor(paymentRequest.amount, currency: paymentRequest.currency)
        return numberFormatter.string(from: majorAmount as NSNumber)!
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
    
    lazy var nameValidator = NameOnCardValidator()
    lazy var numberValidator = CardNumberValidator()
    lazy var expiryValidator = ExpiryValidator()
    lazy var securityCodeValidator = SecurityCodeValidator(getNumber: { self.number })
    
    public init(paymentRequest: PaymentRequest, resultCallback: @escaping ResultCallback) {
        self.paymentRequest = paymentRequest
        self.resultCallback = resultCallback
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
    
    func beingTransaction() {
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
            cvc: securityCode)
        
        let request = ApiPaymentRequest(
            amount: paymentRequest.amount,
            currency: paymentRequest.currency,
            description: paymentRequest.currency,
            callbackUrl: "https://sdk.moyasar.com/return",
            source: ApiPaymentSource.creditCard(source),
            metadata: paymentRequest.metadata.merging(["sdk": "ios"], uniquingKeysWith: {k, _ in k }))
        
        do {
            status = .processing
            
            try paymentService.create(request, handler: {result in
                DispatchQueue.main.async {
                    switch (result) {
                    case .success(let payment):
                        self.currentPayment = payment
                        self.startPaymentAuthProcess()
                        break;
                    case .error(let error):
                        self.resultCallback(.failed(error))
                        break;
                    }
                }
            })
        } catch {
            self.resultCallback(.failed(error))
        }
    }
    
    func startPaymentAuthProcess() {
        guard let payment = currentPayment else {
            let error = MoyasarError.unexpectedError("Current payment is nil")
            resultCallback(.failed(error))
            return
        }
        
        if (!payment.isInitiated()) {
            // Payment status could be paid, failed, authorized, etc...
            resultCallback(.completed(payment))
            return
        }
        
        // set status to paymentAuth and show webview
        guard case let .creditCard(source) = payment.source else {
            let error = MoyasarError.unexpectedError("Initiated payment has invalid source type")
            resultCallback(.failed(error))
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
            resultCallback(.failed(error))
            self.status = .reset
        }
    }
}

enum CreditCardViewModelStatus {
    case reset
    case processing
    case paymentAuth(String)
}


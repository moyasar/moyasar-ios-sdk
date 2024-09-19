//
//  STCPayViewModel.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 11/09/2024.
//

import Combine

@MainActor
public class STCPayViewModel: ObservableObject {
    enum ScreenStep {
        case mobileNumber
        case otp
    }
    @Published var isLoading: Bool = false
    @Published var screenStep: ScreenStep = .mobileNumber
    @Published var isValidPhoneNumber: Bool = false
    @Published var isValidOtp: Bool = false
    @Published var mobileNumber: String = ""  {
        didSet {
            isValidPhoneNumber =  stcValidator.isValidSaudiPhoneNumber(mobileNumber.cleanNumber)
        }
    }
    @Published var otp: String = ""  {
        didSet {
            isValidOtp = stcValidator.isValidOtp(otp)
        }
    }
    lazy var stcValidator = STCValidator()
    lazy var phoneNumberFormatter = PhoneNumberFormatter()
    var transactionUrl: String?
    let paymentRequest: PaymentRequest
    let paymentService: PaymentService
    var resultCallback: STCResultCallback
    
    public init(paymentRequest: PaymentRequest, resultCallback: @escaping STCResultCallback) throws {
        self.paymentRequest = paymentRequest
        self.resultCallback = resultCallback
        self.paymentService = try PaymentService(apiKey: paymentRequest.apiKey)
    }
    
    public func initiatePayment() async {
        guard !mobileNumber.isEmpty else { return }
        isLoading = true
        let request = createApiPaymentRequest()
        do {
            let payment = try await paymentService.createPayment(request)
            if payment.isInitiated(), case .stcPay(let source) = payment.source, let url = source.transactionUrl {
                isLoading = false
                screenStep = .otp
                transactionUrl = url
            }
        } catch {
            isLoading = false
            handleError(error)
        }
    }
    
    public func submitOtp() async {
        guard isValidOtp,
              let transactionUrl = transactionUrl,
              let url = URL(string: transactionUrl)  else { return }
        isLoading = true
        let request = createSTCApiPaymentRequest()
        do {
            let payment = try await paymentService.sendSTCPaymentRequest(url: url, stcOtpRequest: request)
            isLoading = false
            resultCallback(.completed(payment))
        } catch {
            isLoading = false
            handleError(error)
        }
    }
    
    func handleError(_ error: Error) {
        if let moyasarError = error as? MoyasarError {
            resultCallback(.failed(moyasarError))
        } else {
            let callbackError = MoyasarError.unexpectedError("Can't initialize payment: \(error.localizedDescription)")
            resultCallback(.failed(callbackError))
        }
    }
    
    private func createSTCApiPaymentRequest() -> StcOtpRequest {
        return StcOtpRequest(otpValue: otp)
    }
    
    private func createApiPaymentRequest() -> ApiPaymentRequest {
        let source =  ApiSTCPaySource(
            type: "stcpay",
            mobile: mobileNumber,
            referenceNumber: nil,
            branch: paymentRequest.branch,
            cashier: paymentRequest.cashier,
            transactionUrl: nil,
            message: nil
        )
        return ApiPaymentRequest(
            publishableApiKey: paymentRequest.apiKey,
            amount: paymentRequest.amount,
            currency: paymentRequest.currency,
            description: paymentRequest.description,
            source: ApiPaymentSource.stcPay(source)
        )
    }
}

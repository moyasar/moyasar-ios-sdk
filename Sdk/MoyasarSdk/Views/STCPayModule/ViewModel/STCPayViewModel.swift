//
//  STCPayViewModel.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 11/09/2024.
//

import Combine
import Foundation

@MainActor
public class STCPayViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var screenStep: ScreenStep = .mobileNumber
    @Published var isValidPhoneNumber: Bool = false
    @Published var isValidOtp: Bool = false
    @Published var mobileNumber: String = ""
    @Published var otp: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    var showErrorHintView = CurrentValueSubject<Bool, Never>(false)
    lazy var stcValidator = STCValidator()
    lazy var phoneNumberFormatter = PhoneNumberFormatter()
    var transactionUrl: String?
    let paymentRequest: PaymentRequest
    let paymentService: PaymentService
    var resultCallback: STCResultCallback
    enum ScreenStep {
        case mobileNumber
        case otp
    }
    
    public init(paymentRequest: PaymentRequest, resultCallback: @escaping STCResultCallback) {
        self.paymentRequest = paymentRequest
        self.resultCallback = resultCallback
        self.paymentService = PaymentService(apiKey: paymentRequest.apiKey)
        setupBindings()
    }
    
    private func setupBindings() {
        $mobileNumber
            .dropFirst()
            .map { $0.cleanNumber }
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] cleanedNumber in
                guard let self = self else { return }
                cleanedNumber.isEmpty  ?  self.showErrorHintView.send(false) :  self.showErrorHintView.send(true)
                self.isValidPhoneNumber = self.stcValidator.isValidSaudiPhoneNumber(cleanedNumber)
            }
            .store(in: &cancellables)
        
        $otp
            .dropFirst()
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] otp in
                guard let self = self else { return }
                otp.isEmpty  ?  self.showErrorHintView.send(false) :  self.showErrorHintView.send(true)
                self.isValidOtp = self.stcValidator.isValidOtp(otp)
            }
            .store(in: &cancellables)
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
                showErrorHintView.send(false)
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
            resultCallback(.success(payment))
        } catch {
            isLoading = false
            handleError(error)
        }
    }
    
    func handleError(_ error: Error) {
        if let moyasarError = error as? MoyasarError {
            resultCallback(.failure(moyasarError))
        } else {
            let callbackError = MoyasarError.unexpectedError("Can't initialize payment: \(error.localizedDescription)")
            resultCallback(.failure(callbackError))
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
            transactionUrl: nil,
            message: nil
        )
        return ApiPaymentRequest(
            paymentRequest: paymentRequest,
            source: ApiPaymentSource.stcPay(source)
        )
    }
}

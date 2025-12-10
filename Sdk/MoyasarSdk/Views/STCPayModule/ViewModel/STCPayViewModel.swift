//
//  STCPayViewModel.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 11/09/2024.
//

import Combine
import Foundation

/// A view model that manages the STC Pay payment flow.
///
/// Responsibilities:
/// - Validates user input (mobile number and OTP)
/// - Initiates STC Pay payment and advances the UI state
/// - Submits OTP and reports the result via `STCResultCallback`
/// - Exposes observable state for building custom UIs
///
/// Typical usage in a custom view:
/// ```swift
/// let vm = STCPayViewModel(paymentRequest: request) { result in
///     // handle result
/// }
/// // Bind vm.mobileNumber and vm.otp
/// // Call await vm.initiatePayment() then await vm.submitOtp()
/// ```
@MainActor
public class STCPayViewModel: ObservableObject {
    
    /// Indicates whether a network request (initiation or OTP submission) is in progress.
    @Published public var isLoading: Bool = false
    /// Current step in the flow (.mobileNumber then .otp). Use it to switch your UI.
    @Published public var screenStep: ScreenStep = .mobileNumber
    /// True when the entered mobile number is considered valid.
    @Published public var isValidPhoneNumber: Bool = false
    /// True when the entered OTP is considered valid.
    @Published public var isValidOtp: Bool = false
    /// The user's mobile number input. Bind your text field to this.
    @Published public var mobileNumber: String = ""
    /// The user's OTP input. Bind your text field to this.
    @Published public var otp: String = ""
    
    /// Emits true when error hints should be visible (e.g., after user interaction).
    public var showErrorHintView = CurrentValueSubject<Bool, Never>(false)
    /// Utilities for formatting phone numbers (and amounts in related SDK helpers).
    public lazy var phoneNumberFormatter = PhoneNumberFormatter()
    public lazy var stcValidator = STCValidator()

    private var cancellables = Set<AnyCancellable>()
    let layoutDirection = MoyasarLanguageManager.shared.currentLanguage
    var transactionUrl: String?
    let paymentRequest: PaymentRequest
    let paymentService: PaymentService
    var resultCallback: STCResultCallback
    
    /// Represents the current UI step in the STC Pay flow.
    public enum ScreenStep {
        case mobileNumber
        case otp
    }
    
    /// Creates a view model for the given payment request and result callback.
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
    
    /// Begins the STC Pay payment flow after validating the mobile number.
    /// Transitions `screenStep` to `.otp` if initiation succeeds.
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
    
    /// Submits the entered OTP to complete the STC Pay payment.
    /// Calls `resultCallback` with success or failure.
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


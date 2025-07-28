//
//  ApplePayPaymentHandler.swift
//  SwiftUiDemo
//
//  Created by Abdulaziz Alrabiah on 02/12/2023.
//

import MoyasarSdk
import PassKit

class ApplePayPaymentHandler: NSObject, PKPaymentAuthorizationControllerDelegate {
    var applePayService: ApplePayService?
    var controller: PKPaymentAuthorizationController?
    var items = [PKPaymentSummaryItem]()
    var networks: [PKPaymentNetwork] = [
        .amex,
        .mada,
        .masterCard,
        .visa
    ]
    let paymentRequest: PaymentRequest
    
    init(paymentRequest: PaymentRequest) {
        self.paymentRequest = paymentRequest
        do {
            applePayService = try ApplePayService(apiKey: paymentRequest.apiKey, baseUrl: paymentRequest.baseUrl)
        } catch {
            print("Failed to initialize ApplePayService: \(error)")
        }
    }
    
    func present() {
        /// For successset amount to 200 to 300
        items = [
            PKPaymentSummaryItem(label: "Moyasar", amount: 1.00, type: .final)
        ]
        
        let request = PKPaymentRequest()
        
        request.paymentSummaryItems = items
        request.merchantIdentifier = "merchant.com.mysr.apple"
        request.countryCode = "SA"
        request.currencyCode = "SAR"
        request.supportedNetworks = networks
        request.merchantCapabilities = [
            .capability3DS,
            .capabilityCredit,
            .capabilityDebit
        ]
        
        controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller?.delegate = self
        controller?.present(completion: {(p: Bool) in
            print("Presented: " + (p ? "Yes" : "No"))
        })
    }
    
    /// Handles the authorization result of an Apple Pay payment initiated through `PKPaymentAuthorizationController`.
    ///
    /// - Parameters:
    ///   - controller: The `PKPaymentAuthorizationController` managing the Apple Pay payment flow.
    ///   - payment: The `PKPayment` object that contains the tokenized payment information provided by Apple Pay.
    ///   - completion: A completion handler that must be called with a `PKPaymentAuthorizationResult` to inform the system whether the payment was authorized successfully or failed.
    ///
    /// This method:
    /// 1. Asynchronously sends the authorized Apple Pay token to `applePayService` for server-side authorization.
    /// 2. Processes the server response to determine the payment status.
    /// 3. Updates the Apple Pay sheet with the appropriate result by calling the `completion` handler:
    ///    - If the server confirms the payment with status `.paid`, it calls completion with `.success`.
    ///    - If the payment status is `.failed`, it checks if the source is Apple Pay:
    ///        - If yes, it reports the failure reason back to Apple Pay.
    ///        - If no, it reports an unexpected source error.
    ///    - For any other unexpected status, it reports a generic failure message.
    /// 4. If an exception occurs during the authorization process, it calls `completion` with `.failure` and provides the caught error.
    ///
    /// Example:
    /// ```swift
    /// let controller = PKPaymentAuthorizationController(paymentRequest: request)
    /// controller.delegate = self
    /// controller.present(completion: nil)
    /// ```
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        Task {
            do {
                let payment = try await applePayService!.authorizePayment(request: paymentRequest, token: payment.token)
                print("Got payment, status: \(payment.status)")
                print(payment.status)
                print(payment.id)
                
                switch (payment.status) {
                case .paid:
                    if case let .applePay(source) = payment.source {
                        debugPrint( source.referenceNumber ?? "")
                        print( source.token ?? "")
                    }
                    completion(PKPaymentAuthorizationResult(status: .success, errors: []))
                case .failed:
                    if case let .applePay(source) = payment.source {
                        debugPrint(source.message ?? "unspecified")
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: [DemoError.paymentError(source.message ?? "unspecified")]))
                    } else {
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: [DemoError.paymentError("Returned API source is not Apple Pay")]))
                    }
                    
                default:
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: [DemoError.paymentError("Unexpected status returned by API")]))
                }
            } catch {
                // Handle the error case
                print(error)
                completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
            }
        }
    }
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss(completion: {})
    }
}

enum DemoError: Error {
    case paymentError(String)
}

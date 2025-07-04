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

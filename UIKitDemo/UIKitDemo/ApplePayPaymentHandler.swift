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
             applePayService = try ApplePayService(apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3")
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
        request.merchantIdentifier = "merchant.nuha.io.second"
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
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        Task {
            do {
                if let applePayService = applePayService {
                    let paymentResult = try await applePayService.authorizePayment(request: paymentRequest, token: payment.token)
                    // Handle the success case
                    print("Got payment")
                    print(paymentResult.status)
                    print(paymentResult.id)
                    completion(.success)
                } else {
                    // Handle the case where applePayService is nil
                    print("ApplePayService is not initialized")
                    completion(.failure)
                }
            } catch {
                // Handle the error case
                print(error)
                completion(.failure)
            }
        }
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss(completion: {})
    }
}

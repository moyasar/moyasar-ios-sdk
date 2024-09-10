//
//  ApplePayPaymentHandler.swift
//  SwiftUiDemo
//
//  Created by Abdulaziz Alrabiah on 02/12/2023.
//

import MoyasarSdk
import PassKit

class ApplePayPaymentHandler: NSObject, PKPaymentAuthorizationControllerDelegate {
    let paymentRequest: PaymentRequest

    var applePayService: ApplePayService?
    var controller: PKPaymentAuthorizationController?
    var items = [PKPaymentSummaryItem]()
    var networks: [PKPaymentNetwork] = [
        .amex,
        .mada,
        .masterCard,
        .visa
    ]

    init(paymentRequest: PaymentRequest) throws {
        self.paymentRequest = paymentRequest
        self.applePayService = try ApplePayService(apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3")
    }

    func present() {
        items = [
            PKPaymentSummaryItem(label: "Moyasar", amount: 1.00, type: .final)
        ]

        let request = PKPaymentRequest()

        request.paymentSummaryItems = items
        request.merchantIdentifier = "merchant.mysr.fghurayri"
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
                    completion(PKPaymentAuthorizationResult(status: .success, errors: []))
                case .failed:
                    let message: String = if case let .applePay(source) = payment.source {
                        source.message ?? "unspecified"
                    } else {
                        "Returned API source is not Apple Pay"
                    }

                    completion(PKPaymentAuthorizationResult(status: .failure, errors: [DemoError.paymentError(message)]))
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

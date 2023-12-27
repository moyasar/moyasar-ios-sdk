//
//  PaymentViewController.swift
//  UIKitDemo
//
//  Created by Ali Alhoshaiyan on 06/10/2021.
//

import UIKit
import SwiftUI
import MoyasarSdk
import PassKit

let handler = ApplePayPaymentHandler()
let paymentRequest = PaymentRequest(
    apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3",
    amount: 100,
    currency: "SAR",
    description: "Testing iOS SDK",
    metadata: ["order_id": "ios_order_3214124"],
    manual: false,
    createSaveOnlyToken: false
)

let token = ApiTokenRequest(
    name: "source.name",
    number: "source.number",
    cvc: "source.cvc",
    month: "source.month",
    year: "source.year",
    saveOnly: true,
    callbackUrl: "https://sdk.moyasar.com/return"
)

class PaymentViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        let creditCardView = CreditCardView(request: paymentRequest,
                                            callback: handlePaymentResult)
        
        let creditCardHostingController = UIHostingController(rootView: creditCardView)
        creditCardHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(creditCardHostingController)
        view.addSubview(creditCardHostingController.view)
        creditCardHostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            creditCardHostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            creditCardHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            creditCardHostingController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            creditCardHostingController.view.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -100)
        ])
        
        let applePayButton = PKPaymentButton(paymentButtonType: .checkout, paymentButtonStyle: .black)
        applePayButton.addAction(UIAction(handler: handleApplePayPressed), for: .touchUpInside)
        applePayButton.frame.size = CGSize(width: view.frame.width - 30, height: 50)
        applePayButton.frame.origin = CGPoint(x: view.frame.size.width / 2 - applePayButton.frame.size.width / 2, y: view.frame.height - 100)
        view.addSubview(applePayButton)
    }
    
    func handlePaymentResult(_ result: PaymentResult) {
        switch (result) {
        case .completed(let payment):
            if payment.status == .paid {
                presentResultViewController(title: "Thank you for the payment", subtitle: "Your payment ID is " + payment.id)
            } else {
                if case let .creditCard(source) = payment.source, payment.status == .failed {
                    presentResultViewController(title: "Whops 🤭", subtitle: "Something went wrong: " + (source.message ?? ""))
                    print("Payment failed: \(source.message ?? "")")
                } else {
                    // Handle payment statuses
                    presentResultViewController(title: "Thank you for the payment", subtitle: "Your payment ID is " + payment.id)
                    print("Payment: \(payment)")
                }
            }
            break
        case .saveOnlyToken(let token):
            presentResultViewController(title: "Thank you for the token", subtitle: "Your token ID is " + token.id)
            break
        case .failed(let error):
            presentResultViewController(title: "Whops 🤭", subtitle: "Something went wrong: " + error.localizedDescription)
            break
        case .canceled:
            presentResultViewController(title: "Payment operation canceled", subtitle: "")
            break
        @unknown default:
            presentResultViewController(title: "Unknown case 🤔", subtitle: "Check for more cases to cover")
            break
        }
    }
    
    func presentResultViewController(title: String, subtitle: String) {
        let resultVC = ResultViewController(resultTitle: title, resultSubTitle: subtitle)
        resultVC.modalPresentationStyle = .fullScreen
        present(resultVC, animated: true)
    }
    
    func handleApplePayPressed(action: UIAction) {
        handler.present()
    }
}

class ApplePayPaymentHandler: NSObject, PKPaymentAuthorizationControllerDelegate {
    var applePayService = ApplePayService(apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3")
    var controller: PKPaymentAuthorizationController?
    var items = [PKPaymentSummaryItem]()
    var networks: [PKPaymentNetwork] = [
        .amex,
        .mada,
        .masterCard,
        .visa
    ]
    
    override init() {}
    
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
        
        do {
            try applePayService.authorizePayment(request: paymentRequest, token: payment.token) {(result: ApiResult<ApiPayment>) in
                switch (result) {
                case .success(let payment):
                    print("Got payment")
                    print(payment.status)
                    print(payment.id)
                    break;
                case .error(let error):
                    print(error)
                    break;
                }
            }
        } catch {
            print(error)
        }
        
        completion(.success)
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss(completion: {})
    }
}

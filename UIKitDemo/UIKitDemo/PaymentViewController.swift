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


/// No `allowedNetworks` set, defaults to all networks
/// allowedNetworks: [.visa, .mastercard] // Only accept Visa and Mastercard
///  Amount in the smallest currency unit.
/// For example:
/// 10 SAR = 10 * 100 Halalas
/// 10 KWD = 10 * 1000 Fils
/// 10 JPY = 10 JPY (Japanese Yen does not have fractions)
let paymentRequest = PaymentRequest(
    apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3",
    amount: 100,
    currency: "SAR",
    description: "Testing iOS SDK",
    metadata: ["order_id": "ios_order_3214124"],
    manual: false,
    createSaveOnlyToken: false,
    allowedNetworks: [.visa, .mastercard]
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
    
    let handler = ApplePayPaymentHandler(paymentRequest: paymentRequest)

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

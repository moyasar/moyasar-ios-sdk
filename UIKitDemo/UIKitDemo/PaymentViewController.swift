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
    createSaveOnlyToken: false//,
    //allowedNetworks: [.visa, .mastercard]
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
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Moyasar SDK Demo"
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        let creditCardView = CreditCardView(request: paymentRequest,
                                            callback: handlePaymentResult)
        let creditCardHostingController = UIHostingController(rootView: creditCardView)
        creditCardHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(creditCardHostingController)
        contentView.addSubview(creditCardHostingController.view)
        creditCardHostingController.didMove(toParent: self)
        
        let applePayButton = PKPaymentButton(paymentButtonType: .checkout, paymentButtonStyle: .black)
        applePayButton.addAction(UIAction(handler: handleApplePayPressed), for: .touchUpInside)
        
        let stcPayButton = UIButton(type: .system)
        stcPayButton.setTitle("STC Pay Demo", for: .normal)
        stcPayButton.addTarget(self, action: #selector(navigateToSTCView), for: .touchUpInside)
        
        let buttonStackView = UIStackView(arrangedSubviews: [creditCardHostingController.view, applePayButton, stcPayButton])
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 12
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fill
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            buttonStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            applePayButton.heightAnchor.constraint(equalToConstant: 48),
            stcPayButton.heightAnchor.constraint(equalToConstant: 48),
            applePayButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40),
            stcPayButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40)
        ])
    }
    
    @objc func navigateToSTCView() {
        let stcPayView = STCPayView(paymentRequest: paymentRequest) { [weak self] result in
            self?.handleFromSTCResult(result)
        }
        let hostingController = UIHostingController(rootView: stcPayView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func handlePaymentResult(_ result: PaymentResult) {
        switch (result) {
        case let .completed(payment):
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
        case let .saveOnlyToken(token):
            presentResultViewController(title: "Thank you for the token", subtitle: "Your token ID is " + token.id)
            break
        case let .failed(error):
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
    
    func handleFromSTCResult(_ result: STCPaymentResult) {
        switch (result) {
        case let .completed(payment):
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
        case let .failed(error):
            presentResultViewController(title: "Whops 🤭", subtitle: "Something went wrong: " + error.localizedDescription)
        @unknown default:
            presentResultViewController(title: "Unknown case 🤔", subtitle: "Check for more cases to cover")
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

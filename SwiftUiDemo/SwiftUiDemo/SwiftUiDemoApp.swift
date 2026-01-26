//
//  SwiftUiDemoApp.swift
//  SwiftUiDemo
//
//  Created by Ali Alhoshaiyan on 06/10/2021.
//

import SwiftUI
import MoyasarSdk

/// Create Payment Request using `Visa, Mastercard, Mada, AMEX` and `Apple Pay` initializer
/// - Returns: `PaymentRequest`
func createPaymentRequest() -> PaymentRequest{
    /// No `allowedNetworks` set, defaults to all networks
    /// allowedNetworks: [.visa, .mastercard] // Only accept Visa and Mastercard
    ///  Amount in the smallest currency unit.
    /// For example:
    /// 10 SAR = 10 * 100 Halalas
    /// 10 KWD = 10 * 1000 Fils
    /// 10 JPY = 10 JPY (Japanese Yen does not have fractions)
    /// givenID --> A UUID (v4 is recommended) that you generate from your side and attach it with the payment creation request
    /// saveCard -------> if True used to tokenize  Apple pay and Credit Card payments
    /// splits ---> Optional array of PaymentSplit used to distribute the charged amount (in the smallest currency unit) among multiple recipients or to collect a platform fee. Each split requires a recipientId and amount; reference and description are optional. Set feeSource = true to mark the split as a fee/commission taken by the platform. Leave nil to charge the full amount to the default recipient.
    /// Use "pk_test_uQra5pwtUo9GaenMSS4XgfAmeLhmjUTJwFdXJxsH" and "https://apimig.moyasar.com" for staging testing
    do {
        return try PaymentRequest(
            apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3",
            amount: 100,
            currency: "SAR",
            description: "Testing iOS SDK",
            metadata: [ "order_id": .stringValue("ios_order_3214124"),
                        "user_id": .integerValue(12345),
                        "isPremiumUser": .booleanValue(true),
                        "amount": .floatValue(15.5)],
            manual: false,
            //saveCard: true,
            //givenID: "UUID",
            createSaveOnlyToken: false,
            // allowedNetworks: [.visa, .mastercard]
            // payButtonType: .book
          /*splits: [
                PaymentSplit(recipientId: "7d2d0797-a2be-40fe-bb1b-1fdec9824c95",
                             amount: 8000),
                PaymentSplit(recipientId: "327680bb-d790-4643-8e10-31455a1ab3a6",
                             amount: 2000,
                             reference: "optional-reference-for-split-1fcfcbe9-ba75-4eed",
                             description:"Platform processing fee",
                             feeSource: true
                )
            ]*/
        )
    } catch {
        // Handle error here, show error in view model
        fatalError("Invalid api key 🙁")
    }
}

/// Create Payment Request using `STC` initializer
/// - Returns: `PaymentRequest`
func createSTCPaymentRequest() -> PaymentRequest {
    /// Create Payment Request using STC initializer
    /// Amount in the smallest currency unit.
    /// For example:
    /// 10 SAR = 10 * 100 Halalas
    /// 10 KWD = 10 * 1000 Fils
    /// 10 JPY = 10 JPY (Japanese Yen does not have fractions)
    /// givenID --> A UUID (v4 is recommended) that you generate from your side and attach it with the payment creation request
    /// saveCard -------> if True  used to tokenize Apple Pay payment
    /// splits ---> Optional array of PaymentSplit used to distribute the charged amount (in the smallest currency unit) among multiple recipients or to collect a platform fee. Each split requires a recipientId and amount; reference and description are optional. Set feeSource = true to mark the split as a fee/commission taken by the platform. Leave nil to charge the full amount to the default recipient.
    /// Use "pk_test_uQra5pwtUo9GaenMSS4XgfAmeLhmjUTJwFdXJxsH"  & "https://apimig.moyasar.com" For staging testing 
    do {
        return try PaymentRequest(
            apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3",
            amount: 100,
            currency: "SAR",
            description: "Testing iOS SDK",
            metadata: [ "order_id": .stringValue("ios_order_3214124"),
                        "user_id": .integerValue(12345),
                        "isPremiumUser": .booleanValue(true),
                        "amount": .floatValue(15.5)],
            manual: false,
            //saveCard: true,
            //givenID: "UUID",
            createSaveOnlyToken: false,
            // allowedNetworks: [.visa, .mastercard]
            // payButtonType: .book
        /* splits: [
                PaymentSplit(recipientId: "7d2d0797-a2be-40fe-bb1b-1fdec9824c95",
                             amount: 8000),
                PaymentSplit(recipientId: "327680bb-d790-4643-8e10-31455a1ab3a6",
                             amount: 2000,
                             reference: "optional-reference-for-split-1fcfcbe9-ba75-4eed",
                             description:"Platform processing fee",
                             feeSource: true
                )
            ]*/
        )
    } catch {
        // Handle error here, show error in view model
        fatalError("Invalid api key 🙁")
    }
}

@main
struct SwiftUiDemoApp: App {
    
    init () {
        /// If you want the sdk language to be  same as the system language `you don't have to use this manager at all`
        /// If you want to set custom langauge for sdk please use the below line when you lunch the app we support Arabic and English ,
        /// MoyasarLanguageManager.shared.setLanguage(.ar)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

enum MyAppStatus {
    case reset
    case success(ApiPayment)
    case successToken(ApiToken)
    case failed(MoyasarError)
    case unknown(String)
}


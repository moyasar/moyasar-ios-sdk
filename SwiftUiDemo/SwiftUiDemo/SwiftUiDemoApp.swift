//
//  SwiftUiDemoApp.swift
//  SwiftUiDemo
//
//  Created by Ali Alhoshaiyan on 06/10/2021.
//

import SwiftUI
import MoyasarSdk

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
    createSaveOnlyToken: false
   // allowedNetworks: [.visa, .mastercard]
)


@main
struct SwiftUiDemoApp: App {
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


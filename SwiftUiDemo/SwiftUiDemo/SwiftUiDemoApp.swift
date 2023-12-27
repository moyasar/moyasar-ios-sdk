//
//  SwiftUiDemoApp.swift
//  SwiftUiDemo
//
//  Created by Ali Alhoshaiyan on 06/10/2021.
//

import SwiftUI
import MoyasarSdk

let paymentRequest = PaymentRequest(
    apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3",
    amount: 100,
    currency: "SAR",
    description: "Testing iOS SDK",
    metadata: ["order_id": "ios_order_3214124"],
    manual: false,
    createSaveOnlyToken: false
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
    case failed(Error)
    case unknown(String)
}

enum PaymentErrorSample: Error {
    case webViewAuthFailed(String)
}

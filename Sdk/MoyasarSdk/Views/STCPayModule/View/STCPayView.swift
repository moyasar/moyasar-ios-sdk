//
//  STCPayView.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 11/09/2024.
//

import SwiftUI

public struct STCPayView: View {
    /// The observed view model that handles the STC Pay logic.
    @ObservedObject var viewModel: STCPayViewModel
    @Environment(\.colorScheme) private var colorScheme
    var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    /// Initializes the `STCPayView` with a payment request and a callback for handling the payment result.
      ///
      /// - Parameters:
      ///   - paymentRequest: The request containing payment details, including the API key.
      ///   - callback: A closure that gets called when the payment process finishes with success or failure.
    
    public init(paymentRequest: PaymentRequest, callback: @escaping STCResultCallback) {
            viewModel = STCPayViewModel(paymentRequest: paymentRequest, resultCallback: callback)
    }
    
    public var body: some View {
        content
            .environment(\.layoutDirection, viewModel.layoutDirection)
    }
    
    @ViewBuilder
    var content: some View {
        VStack {
            switch viewModel.screenStep {
            case .mobileNumber:
                mobileNumberView
            case .otp:
                otpView
            }
        }.padding()
    }
}

struct STCPayView_Previews: PreviewProvider {
    static var paymentRequest =  try! PaymentRequest(
        apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3",
        amount: 100,
        currency: "SAR",
        description: "Testing iOS SDK"
    )
    static var previews: some View {
        STCPayView(paymentRequest: paymentRequest) { _ in}
        .preferredColorScheme(.dark)
    }
}

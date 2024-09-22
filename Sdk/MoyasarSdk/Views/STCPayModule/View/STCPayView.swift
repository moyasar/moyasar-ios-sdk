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
    
    /// Initializes the `STCPayView` with a payment request and a callback for handling the payment result.
      ///
      /// - Parameters:
      ///   - paymentRequest: The request containing payment details, including the API key.
      ///   - callback: A closure that gets called when the payment process finishes with success or failure.
      ///
      /// - Throws: If the `STCPayViewModel` initialization fails due to an invalid API key,
      /// it throws an error, which is handled by showing a fatal error message.
    public init(paymentRequest: PaymentRequest, callback: @escaping STCResultCallback) {
        do {
            viewModel = try STCPayViewModel(paymentRequest: paymentRequest, resultCallback: callback)
        } catch {
            // Handle error here, show error in view model
            fatalError("Invalid api key 🙁")
        }
    }
    
    public var body: some View {
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
    static var paymentRequest = PaymentRequest(
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

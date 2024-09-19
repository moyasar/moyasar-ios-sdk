//
//  STCPayView.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 11/09/2024.
//

import SwiftUI

public struct STCPayView: View {
    
    @ObservedObject var viewModel: STCPayViewModel
    
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

#Preview {
    var paymentRequest = PaymentRequest(
        apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3",
        amount: 100,
        currency: "SAR",
        description: "Testing iOS SDK"
    )
    return STCPayView(paymentRequest: paymentRequest) { result in
        
    }
}

//
//  CustomSTCView.swift
//  SwiftUiDemo
//
//  Created by Mahmoud Abdelwahab on 09/12/2025.
//

import SwiftUI
import MoyasarSdk

struct MyCustomSTCPayView: View {
    @ObservedObject var viewModel: STCPayViewModel

    init(paymentRequest: PaymentRequest, callback: @escaping STCResultCallback) {
        self._viewModel = ObservedObject(
            wrappedValue: STCPayViewModel(paymentRequest: paymentRequest, resultCallback: callback)
        )
    }
    
    init(viewModel: STCPayViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            switch viewModel.screenStep {
            case .mobileNumber:
                phoneStep
            case .otp:
                otpStep
            }
        }
        .padding()
        .environment(\.layoutDirection, .leftToRight)
    }

    private var phoneStep: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mobile Number")
                .font(.headline)

            TextField("05XXXXXXXX", text: $viewModel.mobileNumber)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            Button(action: { Task { await viewModel.initiatePayment() } }) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Pay")
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(!viewModel.isValidPhoneNumber || viewModel.isLoading)
            .buttonStyle(.borderless)
        }
    }

    private var otpStep: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Enter OTP")
                .font(.headline)

            TextField("XXXXXX", text: $viewModel.otp)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            Button(action: { Task { await viewModel.submitOtp() } }) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Confirm")
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(!viewModel.isValidOtp || viewModel.isLoading)
            .buttonStyle(.borderless)
        }
    }
}

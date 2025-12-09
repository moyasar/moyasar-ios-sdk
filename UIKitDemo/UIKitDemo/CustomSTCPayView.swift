//
//  CustomSTCView.swift
//  SwiftUiDemo
//
//  Created by Mahmoud Abdelwahab on 09/12/2025.
//

import SwiftUI
import MoyasarSdk
import UIKit

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
            PhoneTextField(text: $viewModel.mobileNumber, format: localFormatPhone)
                .frame(height: 50)
            
            if !viewModel.isValidPhoneNumber && viewModel.showErrorHintView.value{
                Text("invalid phone number")
            }
            
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
            let shouldShowHint = (viewModel.showErrorHintView.value && !viewModel.isValidOtp)
            if shouldShowHint {
                Text("invalid OTP")
            }
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

// A UIKit-backed text field that applies formatting and enforces max length as the user types
struct PhoneTextField: UIViewRepresentable {
    @Binding var text: String
    let format: (String) -> String

    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.borderStyle = .roundedRect
        tf.delegate = context.coordinator
        tf.addTarget(context.coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
        return tf
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, format: format)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        let format: (String) -> String

        init(text: Binding<String>, format: @escaping (String) -> String) {
            _text = text
            self.format = format
        }

        @objc func textChanged(_ sender: UITextField) {
            let formatted = format(sender.text ?? "")
            if sender.text != formatted {
                sender.text = formatted
            }
            text = formatted
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let current = textField.text ?? ""
            guard let r = Range(range, in: current) else { return true }
            let proposed = current.replacingCharacters(in: r, with: string)
            // Let the formatter decide normalization, then ensure max 10 digits
            let normalized = format(proposed)
            let digitsCount = normalized.filter { $0.isNumber }.count
            // Always allow deletion
            if string.isEmpty { return true }
            return digitsCount <= 10
        }
    }
}

// Local phone formatter: keep digits only, normalize to start with 05, and hard-limit to 10 digits total
private func localFormatPhone(_ input: String) -> String {
    // Keep only digits
    let rawDigits = input.filter { $0.isNumber }
    // Allow clearing the field entirely
    if rawDigits.isEmpty { return "" }

    // Build a tail (digits after the 05 prefix) regardless of how the user typed
    let tail: String
    if rawDigits.hasPrefix("05") {
        tail = String(rawDigits.dropFirst(2))
    } else if rawDigits.hasPrefix("5") {
        tail = String(rawDigits.dropFirst(1))
    } else if rawDigits.hasPrefix("0") {
        tail = String(rawDigits.dropFirst(1))
    } else {
        tail = rawDigits
    }

    // Compose normalized number starting with 05 then take only 8 more digits
    let normalized = "05" + String(tail.prefix(8))
    return normalized
}

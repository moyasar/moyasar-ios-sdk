//
//  STCPayView+SubViews.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 19/09/2024.
//

import SwiftUI

extension STCPayView {
    
    var mobileNumberView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("mobile-number".localized())
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(MoyasarColors.primaryTextColor)
                Spacer()
            }
            phoneNumberField
            Spacer()
                .frame(height: 34)
            payButtonView
        }
    }
    
    var otpView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("otp-title".localized())
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(MoyasarColors.primaryTextColor)
                Spacer()
            }
            otpField
            Spacer()
                .frame(height: 34)
            continueButtonView
        }
    }
    
    /// View for the "Phone Number" input field, validation.
    var otpField: some View {
        VStack(alignment: .leading) {
            TextField("otp-placeholder".localized(), text: $viewModel.otp)
                .keyboardType(.numberPad)
                .disableAutocorrection(true)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(MoyasarColors.borderColor, lineWidth: 1.5)
                )
                .frame(height: 46)
                .shadow(color: MoyasarColors.borderColor, radius: 3, x: 0, y: 2)
            
            if viewModel.showErrorHintView.value, !viewModel.isValidOtp {
                withAnimation {
                    validationText(for: "invalid-otp".localized())
                }
            }
        }
    }
    
    /// View for the "Phone Number" input field, validation.
    var phoneNumberField: some View {
        VStack(alignment: .leading) {
            CreditCardTextField(
                text: $viewModel.mobileNumber,
                placeholder: "mobile-number-placeholder".localized(),
                formatter: viewModel.phoneNumberFormatter.formatPhoneNumber(_:)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(MoyasarColors.borderColor, lineWidth: 1.5)
            )
            .frame(height: 46)
            .shadow(color: MoyasarColors.borderColor, radius: 3, x: 0, y: 2)
            
            if viewModel.showErrorHintView.value, let validationResult = viewModel.stcValidator.validate(value: viewModel.mobileNumber.cleanNumber) {
                withAnimation {
                    validationText(for: validationResult)
                }
            }
        }
    }
    /// Creates a view that displays validation error text.
    /// - Parameter validationResult: The validation result to display.
    /// - Returns: A view displaying the validation error text.
    private func validationText(for validationResult: String) -> some View {
        Text(validationResult)
            .padding(.horizontal, 5)
            .foregroundColor(.red)
            .font(.caption)
    }
    
    var payButtonView: some View {
        Button(action: {
            Task {
                await viewModel.initiatePayment()
            }
        }, label: {
            HStack {
                if viewModel.isLoading {
                    ActivityIndicator(style: .medium)
                } else {
                    Text(viewModel.phoneNumberFormatter.getFormattedAmount(paymentRequest: viewModel.paymentRequest))
                        .frame(maxWidth: .infinity, minHeight: 25)
                        .contentShape(Rectangle())
                }
            }
        }).disabled(!viewModel.isValidPhoneNumber)
            .frame(maxWidth: .infinity, minHeight: 25)
            .padding(14)
            .background(!viewModel.isValidPhoneNumber ? MoyasarColors.stcButtonColor.opacity(0.6) : MoyasarColors.stcButtonColor)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(10)
    }
    
    var continueButtonView: some View {
        Button(action: {
            Task {
                await viewModel.submitOtp()
            }
        }, label: {
            HStack {
                if viewModel.isLoading {
                    ActivityIndicator(style: .medium)
                } else {
                    Text("confirm".localized())
                        .frame(maxWidth: .infinity, minHeight: 25)
                        .contentShape(Rectangle())
                }
            }
        }).disabled(!viewModel.isValidOtp)
            .frame(maxWidth: .infinity, minHeight: 25)
            .padding(14)
            .background(!viewModel.isValidOtp ? MoyasarColors.stcButtonColor.opacity(0.6) : MoyasarColors.stcButtonColor)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(10)
    }
}

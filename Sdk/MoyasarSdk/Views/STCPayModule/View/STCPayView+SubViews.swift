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
                let validatedText = viewModel.stcValidator.validate(value: viewModel.mobileNumber.cleanNumber)
                let shouldShowHint = (viewModel.showErrorHintView.value && validatedText != nil)
                Text((shouldShowHint ? validatedText : "mobile-number".localized()) ?? "mobile-number".localized())
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(shouldShowHint ? .red : MoyasarColors.primaryTextColor)
                Spacer()
            }
            phoneNumberField
            Spacer()
                .frame(height: 34)
            payButtonView
        }
    }
    
    /// View for the "Phone Number" input field, validation.
    var phoneNumberField: some View {
        VStack(alignment: .leading) {
            let validatedText = viewModel.stcValidator.validate(value: viewModel.mobileNumber.cleanNumber)
            let shouldShowHint = (viewModel.showErrorHintView.value && validatedText != nil)
            CreditCardTextField(
                text: Binding(
                                get: {
                                    viewModel.mobileNumber
                                },
                                set: { newValue in
                                    if !newValue.hasPrefix("05") {
                                        viewModel.mobileNumber = "05" + newValue.drop(while: { $0 == "0" || $0 == "5" })
                                    } else {
                                        viewModel.mobileNumber = newValue
                                    }
                                }
                            ),
                placeholder: "mobile-number-placeholder".localized(),
                formatter: viewModel.phoneNumberFormatter.formatPhoneNumber(_:)
            ).padding(.horizontal,10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(shouldShowHint ? .red : MoyasarColors.borderColor, lineWidth: 1)
                   // .stroke(MoyasarColors.borderColor, lineWidth: 1.5)
            )
            .frame(height: 46)
            .shadow(color: MoyasarColors.borderColor, radius: 3, x: 0, y: 2)
        }
    }
    
    var otpView: some View {
        VStack(alignment: .leading) {
            HStack {
                let shouldShowHint = (viewModel.showErrorHintView.value && !viewModel.isValidOtp)
                Text(shouldShowHint ? "invalid-otp".localized() : "otp-title".localized())
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(shouldShowHint ? .red : MoyasarColors.primaryTextColor)
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
            let shouldShowHint = (viewModel.showErrorHintView.value && !viewModel.isValidOtp)
            TextField("otp-placeholder".localized(), text: $viewModel.otp)
                .keyboardType(.numberPad)
                .disableAutocorrection(true)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(shouldShowHint ? Color.red :MoyasarColors.borderColor, lineWidth: 1))
                .frame(height: 46)
                .shadow(color: MoyasarColors.borderColor, radius: 3, x: 0, y: 2)
        }
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

//
//  CreditCardView+Views.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 30/06/2024.
//

import SwiftUI

extension CreditCardView {
    /// The main content of the credit card view.
    @ViewBuilder
    var content: some View {
        if (showAuth) {
            PaymentAuthView(url: authUrl!) {r in viewModel.handleWebViewResult(r)}
        } else {
            creditCardContainerView
        }
    }
    
    /// The container view for credit card details and action button.
    var creditCardContainerView: some View {
        ZStack {
            VStack {
                CreditCardInfoView(cardInfo: viewModel)
                Spacer()
                errorView
                payButtonView
            }
            .disabled(shouldDisable())
            .padding()
        }
    }
    
    /// A view that displays any error message.
    var errorView: some View {
        Text(viewModel.error ?? "")
            .foregroundColor(.red)
            .padding(.bottom)
        
    }
    
    /// The button view for initiating the payment.
    var payButtonView: some View {
        Button(action: {
            Task {
                await viewModel.beginTransaction()
            }
        }, label: {
            HStack {
                if (shouldDisable()) {
                    ActivityIndicator(style: .medium)
                } else {
                    HStack(spacing: 0) {
                            if viewModel.layoutDirection == .leftToRight {
                                // English and LTR languages
                                Text(viewModel.paymentRequest.payButtonType.title)
                                    .padding(.horizontal, 3)
                        "sar".sdkImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundColor(Color.white)
                                Text(viewModel.formattedAmount)
                            } else {
                                // RTL languages like Arabic
                                Text(viewModel.paymentRequest.payButtonType.title)
                                    .padding(.horizontal, 3)
                                Text(viewModel.formattedAmount)
                                "sar".sdkImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundColor(Color.white)
                            }
                    }
                    .frame(maxWidth: .infinity, minHeight: 25)
                    .contentShape(Rectangle())
                }
            }
        }).disabled(!viewModel.isValid)
            .frame(maxWidth: .infinity, minHeight: 25)
            .padding(14)
            .background(shouldDisable() || !viewModel.isValid ? buttonColor.opacity(0.6) : buttonColor)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(10)
    }
}

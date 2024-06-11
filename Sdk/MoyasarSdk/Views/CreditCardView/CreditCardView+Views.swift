//
//  CreditCardView+Views.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 11/06/2024.
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
            viewModel.beingTransaction()
        }, label: {
            HStack {
                if (shouldDisable()) {
                    ActivityIndicator(style: .medium)
                } else {
                    Text(viewModel.formattedAmount)
                }
            }
        }).disabled(!viewModel.isValid)
        .frame(maxWidth: .infinity, minHeight: 25)
        .padding(14)
        .foregroundColor(.white)
        .font(.headline)
        .background(shouldDisable() || !viewModel.isValid ? buttonColor.opacity(0.6) : buttonColor)
        .cornerRadius(10)
    }
}

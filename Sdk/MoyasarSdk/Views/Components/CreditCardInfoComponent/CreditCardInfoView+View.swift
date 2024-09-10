//
//  CreditCardInfoView+View.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 30/06/2024.
//

import SwiftUI
import Combine

extension CreditCardInfoView {
    // MARK: - Subviews
    
    /// View for the "Name on Card" input field and validation.
    var nameField: some View {
        VStack(alignment: .leading) {
            creditCardTextField(
                title: "name-on-card".localized(),
                text: $cardInfo.nameOnCard,
                keyboardType: .default,
                autocapitalization: .none,
                disableAutocorrection: true
            )
            validationText(for: cardInfo.nameValidator.visualValidate(value: cardInfo.nameOnCard))
        }
    }
    
    /// View for the "Card Number" input field, validation, and logos.
    var cardNumberField: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .trailing) {
                CreditCardTextField(
                                   text: $cardInfo.number,
                                   placeholder: "card-number".localized(),
                                   formatter: cardInfo.formatter.formatCardNumber(_:)
                ).frame(height: 46)
                cardNetworkLogos
            }
            validationText(for: cardInfo.numberValidator.visualValidate(value: cardInfo.number))
        }
    }
    
    /// View for the "Expiry Date" input field and validation.
    var expiryDateField: some View {
        VStack(alignment: .leading) {
            CreditCardTextField(
                           text: $cardInfo.expiryDate,
                           placeholder: "expiry".localized(),
                           formatter: cardInfo.formatter.formatExpiryDate
                       ).frame(height: 46)
            validationText(for: cardInfo.expiryValidator.visualValidate(value: cardInfo.expiryDate))
        }
    }
    
    /// View for the "CVC Code" input field and validation.
    var cvcField: some View {
        VStack(alignment: .leading) {
            CreditCardTextField(
                           text: Binding(
                               get: { cardInfo.securityCode },
                               set: { cardInfo.securityCode = cardInfo.formatter.formatCVC($0, forCardNumber: cardInfo.number) }
                           ),
                           placeholder: "cvc".localized(),
                           formatter: { $0 }
                       ).frame(height: 46)
            validationText(for: cardInfo.securityCodeValidator.visualValidate(value: cardInfo.securityCode))
        }
    }
    
    // MARK: - Reusable Views
    
    /// Creates a reusable text field for credit card information.
      /// - Parameters:
      ///   - title: The placeholder title for the text field.
      ///   - text: A binding to the text field's value.
      ///   - keyboardType: The keyboard type for the text field.
      ///   - autocapitalization: The text field's autocapitalization setting.
      ///   - disableAutocorrection: A Boolean value that indicates whether to disable autocorrection.
      /// - Returns: A configured `TextField`.
    private func creditCardTextField(
        title: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType,
        autocapitalization: UITextAutocapitalizationType,
        disableAutocorrection: Bool,
        formatter: @escaping (String) -> String = { $0 } // Default formatter does nothing
    ) -> some View {
        TextField(title, text: Binding(
            get: { text.wrappedValue },
            set: { newValue in
                text.wrappedValue = formatter(newValue)
            }
        ))
        .keyboardType(keyboardType)
        .autocapitalization(autocapitalization)
        .disableAutocorrection(disableAutocorrection)
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 0.4)
        )
    }

      
    
    /// Creates a view that displays validation error text.
    /// - Parameter validationResult: The validation result to display.
    /// - Returns: A view displaying the validation error text.
    private func validationText(for validationResult: String?) -> some View {
        Text(validationResult ?? " ")
            .padding(.horizontal, 5)
            .foregroundColor(.red)
            .font(.caption)
    }
    
    /// View for displaying card network logos.
    private var cardNetworkLogos: some View {
        HStack {
            if cardInfo.showNetworkLogo(.mada) {
                "mada".sdkImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            if cardInfo.showNetworkLogo(.visa) {
                "visa".sdkImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            if cardInfo.showNetworkLogo(.mastercard) {
                "mastercard".sdkImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            if cardInfo.showNetworkLogo(.amex) {
                "amex".sdkImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(height: 26)
        .padding(.trailing, 7)
    }
}


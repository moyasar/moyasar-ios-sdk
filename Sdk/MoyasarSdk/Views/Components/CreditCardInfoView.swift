import SwiftUI

/// A view that displays input fields for credit card information.
struct CreditCardInfoView: View {
    @ObservedObject var cardInfo: CreditCardViewModel
    @Environment(\.locale) var locale: Locale
    
    var body: some View {
        VStack(alignment: .leading) {
            // Name on Card
            nameField
            
            // Card Number
            cardNumberField
            
            // Expiry Date
            expiryDateField
            
            // CVC Code
            cvcField
        }
    }
}


extension CreditCardInfoView {
    // MARK: - Subviews
    
    /// View for the "Name on Card" input field and validation.
    private var nameField: some View {
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
    private var cardNumberField: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .trailing) {
                creditCardTextField(
                    title: "card-number".localized(),
                    text: $cardInfo.number,
                    keyboardType: .numberPad,
                    autocapitalization: .none,
                    disableAutocorrection: true
                )
                cardNetworkLogos
            }
            validationText(for: cardInfo.numberValidator.visualValidate(value: cardInfo.number))
        }
    }
    
    /// View for the "Expiry Date" input field and validation.
    private var expiryDateField: some View {
        VStack(alignment: .leading) {
            creditCardTextField(
                title: "expiry".localized(),
                text: $cardInfo.expiryDate,
                keyboardType: .numberPad,
                autocapitalization: .none,
                disableAutocorrection: true
            )
            validationText(for: cardInfo.expiryValidator.visualValidate(value: cardInfo.expiryDate))
        }
    }
    
    /// View for the "CVC Code" input field and validation.
    private var cvcField: some View {
        VStack(alignment: .leading) {
            creditCardTextField(
                title: "cvc".localized(),
                text: $cardInfo.securityCode,
                keyboardType: .numberPad,
                autocapitalization: .none,
                disableAutocorrection: true
            )
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
        disableAutocorrection: Bool
    ) -> some View {
        TextField(title, text: text)
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



// MARK: - Preview

struct CreditCardInfoView_Previews: PreviewProvider {
    static var paymentRequest = PaymentRequest(
        apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3",
        amount: 100,
        currency: "SAR",
        description: "Testing iOS SDK"
    )

    static var info = CreditCardViewModel(paymentRequest: paymentRequest) { result in
        switch result {
        case .completed(let payment):
            print("Got payment")
            print("Payment status \(payment.status)")
            print("Payment ID: \(payment.id)")
        case .saveOnlyToken(let token):
            print("Got token")
            print("Token status \(token.status)")
            print("Token ID: \(token.id)")
        case .failed(let error):
            print("Got an error: \(error.localizedDescription)")
        case .canceled:
            print("Operation canceled")
        }
    }

    static var previews: some View {
        CreditCardInfoView(cardInfo: info)
            .preferredColorScheme(.light)
        
        CreditCardInfoView(cardInfo: info)
            .preferredColorScheme(.dark)
    }
}


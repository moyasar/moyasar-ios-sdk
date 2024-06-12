import SwiftUI

struct CreditCardInfoView: View {
    @ObservedObject var cardInfo: CreditCardViewModel
    @Environment(\.locale) var locale: Locale

    var body: some View {
        VStack(alignment: .leading) {
            TextField("name-on-card".localized(), text: $cardInfo.nameOnCard)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0), lineWidth: 0.4)
                )

            Text(cardInfo.nameValidator.visualValidate(value: cardInfo.nameOnCard) ?? " ")
                .padding(.horizontal, 5)
                .foregroundColor(.red)
                .font(.caption)

            ZStack(alignment: .trailing) {
                TextField("card-number".localized(), text: $cardInfo.number)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0), lineWidth: 0.4)
                    )

                HStack {
                    if (cardInfo.showNetworkLogo(.mada)) {
                        "mada".sdkImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }

                    if (cardInfo.showNetworkLogo(.visa)) {
                        "visa".sdkImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }

                    if (cardInfo.showNetworkLogo(.mastercard)) {
                        "mastercard".sdkImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }

                    if (cardInfo.showNetworkLogo(.amex)) {
                        "amex".sdkImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .frame(height: 26)
                .padding(.trailing, 7)
            }

            Text(cardInfo.numberValidator.visualValidate(value: cardInfo.number) ?? " ")
                .padding(.horizontal, 5)
                .foregroundColor(.red)
                .font(.caption)

             TextField("expiry".localized(), text: $cardInfo.expiryDate)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.numberPad)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0), lineWidth: 0.4)
                )

            Text(cardInfo.expiryValidator.visualValidate(value: cardInfo.expiryDate) ?? " ")
                .padding(.horizontal, 5)
                .foregroundColor(.red)
                .font(.caption)

            TextField("cvc".localized(), text: $cardInfo.securityCode)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.numberPad)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0), lineWidth: 0.4)
                )

            Text(cardInfo.securityCodeValidator.visualValidate(value: cardInfo.securityCode) ?? " ")
                .padding(.horizontal, 5)
                .foregroundColor(.red)
                .font(.caption)
        }
    }
}

struct CreditCardInfoView_Previews: PreviewProvider {
    static var paymentRequest = PaymentRequest(
        apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3",
        amount: 100,
        currency: "SAR",
        description: "Testing iOS SDK"
    )

    static var previews: some View {
        do {
            let info = try CreditCardViewModel(paymentRequest: paymentRequest) { result in
                switch (result) {
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
            return AnyView(CreditCardInfoView(cardInfo: info))
        } catch {
            // Handle error here
            // For example, print the error
            print("Failed to initialize CreditCardViewModel: \(error)")
            // Return some placeholder view or handle the error in another way
            return AnyView(Text("Failed to initialize CreditCardViewModel")
                .foregroundColor(.red))
        }
    }
}

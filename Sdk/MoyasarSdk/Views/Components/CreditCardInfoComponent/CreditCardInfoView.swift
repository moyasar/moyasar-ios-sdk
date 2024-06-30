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

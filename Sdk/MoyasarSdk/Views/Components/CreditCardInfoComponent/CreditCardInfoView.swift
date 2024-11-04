import SwiftUI

/// A view that displays input fields for credit card information.
struct CreditCardInfoView: View {
    @ObservedObject var cardInfo: CreditCardViewModel
    @Environment(\.locale) var locale: Locale
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Name on Card
            nameField
            cardView
        }
    }
}




struct CreditCardInfoView_Previews: PreviewProvider {
    static var paymentRequest = try! PaymentRequest(
        apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3",
        amount: 100,
        currency: "SAR",
        description: "Testing iOS SDK"
    )
    
    static var previews: some View {
            let info = CreditCardViewModel(paymentRequest: paymentRequest) { result in
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
    }
}

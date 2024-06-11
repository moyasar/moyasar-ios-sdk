import SwiftUI

/// A view that displays a credit card payment interface.

public struct CreditCardView: View {
    @ObservedObject var viewModel: CreditCardViewModel
    
    let buttonColor = Color(red: 0.137, green: 0.359, blue: 0.882)
    
    /// Initializes a new instance of `CreditCardView`.
       ///
       /// - Parameters:
       ///   - request: The payment request containing details for the transaction.
       ///   - callback: A callback that handles the result of the payment.
    public init(request: PaymentRequest, callback: @escaping ResultCallback) {
        viewModel = CreditCardViewModel(
            paymentRequest: request,
            resultCallback: callback)
    }
    
    /// The content of the view.
    public var body: some View {
        content
    }
}

struct CreditCardView_Previews: PreviewProvider {
    static var paymentRequest = PaymentRequest(
        apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3",
        amount: 100,
        currency: "SAR",
        description: "Testing iOS SDK"
    )
    
    static var previews: some View {
        CreditCardView(request: paymentRequest) {_ in
            print("Got a Result")
        }
        
        CreditCardView(request: paymentRequest) {_ in
            print("Got a Result")
        }
        .preferredColorScheme(.dark)
    }
}

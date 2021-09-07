import SwiftUI

public struct CreditCardView: View {
    @ObservedObject var viewModel: CreditCardViewModel
    
    public init(request: PaymentRequest) {
        viewModel = CreditCardViewModel(paymentRequest: request)
    }
    
    public var body: some View {
        VStack {
            Image("card-place-holder")
                .frame(height: 50.0)
                .offset(y: -300)
                .scaleEffect(1.2)
            
            CreditCardInfoView(cardInfo: viewModel)
            
            Spacer()
            
            Button(action: {
                viewModel.beingTransaction()
            }, label: {
                Text("Pay")
            }).disabled(!viewModel.isValid)
        }
        .disabled(viewModel.status != .reset)
    }
}

struct CreditCardView_Previews: PreviewProvider {
    static var paymentRequest = PaymentRequest(
        amount: 100,
        currency: "SAR",
        description: "Testing iOS SDK",
        apiKey: "pk_live_TH6rVePGHRwuJaAtoJ1LsRfeKYovZgC1uddh7NdX"
    )
    
    static var previews: some View {
        CreditCardView(request: paymentRequest)
    }
}

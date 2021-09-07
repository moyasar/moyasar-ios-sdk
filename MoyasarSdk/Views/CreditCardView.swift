import SwiftUI

public struct CreditCardView: View {
    @ObservedObject var viewModel: CreditCardViewModel
    var callback: ResultCallback
    
    public init(request: PaymentRequest, callback: @escaping ResultCallback) {
        viewModel = CreditCardViewModel(paymentRequest: request)
        self.callback = callback
    }
    
    public var body: some View {
        VStack {
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
        CreditCardView(request: paymentRequest) {_ in 
            print("Got a Result")
        }
    }
}

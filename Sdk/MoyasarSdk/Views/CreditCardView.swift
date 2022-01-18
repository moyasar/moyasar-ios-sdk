import SwiftUI

public struct CreditCardView: View {
    @ObservedObject var viewModel: CreditCardViewModel
    
    let buttonColor = Color(red: 0.137, green: 0.359, blue: 0.882)

    public init(request: PaymentRequest, callback: @escaping ResultCallback) {
        viewModel = CreditCardViewModel(
            paymentRequest: request,
            resultCallback: callback)
    }
    
    @ViewBuilder
    public var body: some View {
        if (showAuth) {
            PaymentAuthView(url: authUrl!) {r in viewModel.handleWebViewResult(r)}
        } else {
            ZStack {
                VStack {
                    CreditCardInfoView(cardInfo: viewModel)

                    Spacer()
                    
                    Text(viewModel.error ?? "")
                        .foregroundColor(.red)
                        .padding(.bottom)

                    Button(action: {
                        viewModel.beingTransaction()
                    }, label: {
                        HStack {
                            if (shoudDisable()) {
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
                    .background(shoudDisable() || !viewModel.isValid ? buttonColor.opacity(0.6) : buttonColor)
                    .cornerRadius(10)
                }
                .disabled(shoudDisable())
                .padding()
            }
        }
    }
    
    private func shoudDisable() -> Bool {
        switch (viewModel.status) {
        case .reset:
            return false
        default:
            return true
        }
    }

    var showAuth: Bool {
        if case .paymentAuth(_) = viewModel.status {
            return true
        }
        return false
    }
    
    var authUrl: URL? {
        if case .paymentAuth(let url) = viewModel.status {
            return URL(string: url)!
        }
        return nil
    }
}

struct CreditCardView_Previews: PreviewProvider {
    static var paymentRequest = PaymentRequest(
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

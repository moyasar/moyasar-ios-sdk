import SwiftUI

public struct CreditCardView: View {
    @ObservedObject var viewModel: CreditCardViewModel

    let buttonColor = Color(red: 0.137, green: 0.359, blue: 0.882)

    public init(request: PaymentRequest, callback: @escaping ResultCallback) {
        do {
            viewModel = try CreditCardViewModel(paymentRequest: request, resultCallback: callback)
        } catch {
            // Handle error here, show error in view model
            viewModel = try! CreditCardViewModel(paymentRequest: request, resultCallback: callback)
            viewModel.error = "Failed to initialize CreditCardViewModel: \(error)"
        }
    }

    @ViewBuilder
    public var body: some View {
        if viewModel.showAuth {
            PaymentAuthView(url: viewModel.authUrl!) { result in
                viewModel.handleWebViewResult(result)
            }
        } else {
            ZStack {
                VStack {
                    CreditCardInfoView(cardInfo: viewModel)

                    Spacer()

                    Text(viewModel.error ?? "")
                        .foregroundColor(.red)
                        .padding(.bottom)

                    Button(action: {
                        Task {
                         await   viewModel.beginTransaction()
                        }
                    }, label: {
                        HStack {
                            if viewModel.shoudDisable() {
                                ActivityIndicator(style: .medium)
                            } else {
                                Text(viewModel.formattedAmount)
                            }
                        }
                    }).disabled(viewModel.shoudDisable() || !viewModel.isValid)
                    .frame(maxWidth: .infinity, minHeight: 25)
                    .padding(14)
                    .foregroundColor(.white)
                    .font(.headline)
                    .background(viewModel.shoudDisable() || !viewModel.isValid ? buttonColor.opacity(0.6) : buttonColor)
                    .cornerRadius(10)
                }
                .disabled(viewModel.shoudDisable())
                .padding()
            }
        }
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

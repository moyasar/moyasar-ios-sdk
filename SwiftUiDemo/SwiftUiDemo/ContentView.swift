import SwiftUI
import MoyasarSdk
import PassKit

// Below is a demo of how to use Moyasar's SDK

fileprivate let handler = ApplePayPaymentHandler(paymentRequest: paymentRequest)
fileprivate let token = ApiTokenRequest(
    name: "source.name",
    number: "source.number",
    cvc: "source.cvc",
    month: "source.month",
    year: "source.year",
    saveOnly: true,
    callbackUrl: "https://sdk.moyasar.com/return"
)

struct ContentView: View {
    @State var status = MyAppStatus.reset

    @ViewBuilder
    var body: some View {
        if case .reset = status {
            NavigationView {
                VStack {
                    Text("hello")
                        .padding()
                    
                    CreditCardView(request: paymentRequest) {result in
                        handleFromResult(result)
                    }
                    
                    ApplePayButton(action: UIAction(handler: applePayPressed))
                        .frame(height: 50)
                        .cornerRadius(10)
                        .padding(.horizontal, 15)
                    
                    NavigationLink(destination: CustomView()) {
                        Text("Checkout custom UI demo")
                    }
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                }
            }
        } else if case let .success(payment) = status {
            VStack {
                Text("Thank you for the payment")
                    .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Text("Your payment ID is " + payment.id)
                    .font(.caption)
            }
        } else if case let .successToken(token) = status {
            VStack {
                Text("Thank you for the token")
                    .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Text("Your token ID is " + token.id)
                    .font(.caption)
            }
        } else if case let .failed(error) = status {
            Text("Whops 🤭")
                .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Text("Something went wrong: " + error.localizedDescription)
                .font(.caption)
        } else if case let .unknown(string) = status {
            Text("Hmmmmm 🤔")
                .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Text("Something went wrong: " + string)
                .font(.caption)
        }
    }
    
    func handleFromResult(_ result: PaymentResult) {
        switch (result) {
        case .completed(let payment):
            if payment.status == .paid {
                status = .success(payment)
            } else {
                if case let .creditCard(source) = payment.source, payment.status == .failed {
                    status = .failed(PaymentErrorSample.webViewAuthFailed(source.message ?? ""))
                    print("Payment failed: \(source.message ?? "")")
                } else {
                    // Handle payment statuses
                    status = .success(payment)
                    print("Payment: \(payment)")
                }
            }
            break;
        case .saveOnlyToken(let token):
            status = .successToken(token)
            break;
        case .failed(let error):
            status = .failed(error)
            break;
        case .canceled:
            status = .reset
            break;
        @unknown default:
            status = .unknown("Unknown case, check for more cases to cover")
            break;
        }
    }
    
    func applePayPressed(action: UIAction) {
        handler.present()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: "ar"))
            .preferredColorScheme(.dark)
    }
}

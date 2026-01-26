import SwiftUI
import MoyasarSdk
import PassKit

// Below is a demo of how to use Moyasar's SDK

fileprivate let token = ApiTokenRequest(
    name: "source.name",
    number: "source.number",
    cvc: "source.cvc",
    month: "source.month",
    year: "source.year",
    saveOnly: true,
    callbackUrl: "https://sdk.moyasar.com/return"
)
let applePayHandler =  ApplePayPaymentHandler(paymentRequest: createPaymentRequest())

struct ContentView: View {
    @State var status = MyAppStatus.reset
    @State private var showCreditCardView = false

    @ViewBuilder
    var body: some View {
        if case .reset = status {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        // Top-centered Moyasar logo
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 64) // adjust as needed
                            .padding(.top, 48)

                        Text("Moyasar SDK Demo")
                            .font(.title)
                            .padding()

                        // Button to show credit card view in a sheet
                        Button(action: {
                            showCreditCardView = true
                        }) {
                            HStack {
                                Image(systemName: "creditcard")
                                Text("Pay with Credit Card Demo")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .sheet(isPresented: $showCreditCardView) {
                            NavigationView {
                                CreditCardView(request: createPaymentRequest()) { result in
                                    handleFromResult(result)
                                    showCreditCardView = false
                                }
                                .navigationTitle("Add Payment Method")
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Cancel") {
                                            showCreditCardView = false
                                        }
                                    }
                                }
                            }
                        }

                        ApplePayButton(action: UIAction(handler: applePayPressed))
                            .frame(height: 50)
                            .cornerRadius(10)
                            .padding(.horizontal, 15)

                        NavigationLink(destination:  STCPayView(paymentRequest: createSTCPaymentRequest()){ result in
                            handleFromSTCResult(result)
                        }) {
                            Text("STC Pay Demo")
                        }
                        .padding(EdgeInsets(top: 16, leading: 0, bottom: 10, trailing: 0))

                        NavigationLink(destination: MyCustomSTCPayView(viewModel: STCPayViewModel(paymentRequest: createSTCPaymentRequest()) { result in
                            handleFromSTCResult(result)
                        })) {
                            Text("Custom STC Pay UI demo")
                        }
                        .padding(EdgeInsets(top: 16, leading: 0, bottom: 10, trailing: 0))

                        NavigationLink(destination: CustomView()) {
                            Text("Checkout custom UI demo")
                        }
                        .padding(EdgeInsets(top: 16, leading: 0, bottom: 10, trailing: 0))
                    }
                    .frame(maxWidth: .infinity) // Ensure center alignment in ScrollView
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
            Text("Something went wrong: " + moyasarErrorToString(error))
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
        case let .completed(payment):
            if payment.status == .paid {
                status = .success(payment)
            } else {
                if case let .creditCard(source) = payment.source, payment.status == .failed {
                    status = .unknown(source.message ?? "")
                    print("Payment failed: \(source.message ?? "")")
                } else {
                    // Handle payment statuses
                    status = .success(payment)
                    print("Payment: \(payment)")
                }
            }
            break;
        case let .saveOnlyToken(token):
            status = .successToken(token)
            break;
        case let .failed(error):
            status = .failed(error)
        case .canceled:
            status = .reset
            break;
        @unknown default:
            status = .unknown("Unknown case, check for more cases to cover")
            break;
        }
    }

    func handleFromSTCResult(_ result:  Result<ApiPayment, MoyasarError>) {
        switch (result) {
        case let .success(payment):
            if payment.status == .paid {
                status = .success(payment)
            } else {
                if case let .stcPay(source) = payment.source, payment.status == .failed {
                    status = .unknown(source.message ?? "")
                    print("Payment failed: \(source.message ?? "")")
                } else {
                    // Handle payment statuses
                    status = .success(payment)
                    print("Payment: \(payment)")
                }
            }

        case let .failure(error):
            status = .failed(error)
        }
    }

    func applePayPressed(action: UIAction) {
        applePayHandler.present()
    }

    func encloseMoyasarError(_ error: Error) -> MoyasarError {
        if let moyasarError = error as? MoyasarError {
            return moyasarError
        } else {
            return MoyasarError.unexpectedError(error.localizedDescription)
        }
    }

    func moyasarErrorToString(_ error: MoyasarError) -> String {
        switch (error) {
        case let .apiError(apiError):
            return apiError.message ?? "unspcified api error";
        case .apiKeyNotSet:
            return "API Key is not set";
        case let .authorizationError(intError):
            return intError;
        case let .invalidApiKey(intError):
            return intError;
        case let .networkError(intError):
            return intError.localizedDescription;
        case let .webviewNotConnectedToInternet(payment):
            return "Webview cannot connect to internet, payment id: \(payment.id)";
        case let .webviewTimedOut(payment):
            return "Webview timed out, payment id: \(payment.id)";
        case let .webviewUnexpectedError(payment, webviewError):
            return "Webview error, payment id: \(payment.id). Error: \(webviewError.localizedDescription)";
        case let.unexpectedError(intError):
            return intError
        default:
            return "Unexpected error"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: "ar"))
            .preferredColorScheme(.dark)
    }
}

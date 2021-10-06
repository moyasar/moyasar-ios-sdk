import SwiftUI
import MoyasarSdk
import PassKit

let handler = PaymentHandler()
let paymentRequest = PaymentRequest(
    amount: 100,
    currency: "SAR",
    description: "Testing iOS SDK",
    metadata: ["order_id": "ios_order_3214124"]
)

struct ContentView: View {
    @State var status = MyAppStatus.reset
    
    init() {
        Moyasar.baseUrl = "https://apimig.moyasar.com/"
        try! Moyasar.setApiKey("pk_live_TH6rVePGHRwuJaAtoJ1LsRfeKYovZgC1uddh7NdX")
//        try! Moyasar.setApiKey("pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3")
        
    }

    @ViewBuilder
    var body: some View {
        if case .reset = status {
            VStack {
                CreditCardView(request: paymentRequest) {result in
                    handleFormResult(result)
                }
                ApplePayButton(action: UIAction(handler: applePayPressed))
                    .frame(height: 50)
                    .padding(.horizontal, 15)
            }
        } else if case let .success(payment) = status {
            VStack {
                Text("Thank you for the payment")
                    .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Text("Your payment ID is " + payment.id)
                    .font(.caption)
            }
        } else if case let .failed(error) = status {
            Text("Whops 🤭")
                .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Text("Something went wrong: " + error.localizedDescription)
                .font(.caption)
        }
    }
    
    func handleFormResult(_ result: PaymentResult) {
        switch (result) {
        case .completed(let payment):
            status = .success(payment)
            break;
        case .failed(let error):
            status = .failed(error)
            break;
        case .canceled:
            status = .reset
            break;
        }
    }
    
    func applePayPressed(action: UIAction) {
        handler.present()
    }
}

class PaymentHandler: NSObject, PKPaymentAuthorizationControllerDelegate {
    var applePayService = ApplePayService()
    var controller: PKPaymentAuthorizationController?
    var items = [PKPaymentSummaryItem]()
    var networks: [PKPaymentNetwork] = [
        .amex,
        .mada,
        .masterCard,
        .visa
    ]
    
    override init() {}
    
    func present() {
        items = [
            PKPaymentSummaryItem(label: "Moyasar", amount: 1.00, type: .final)
        ]
        
        let request = PKPaymentRequest()
        
        request.paymentSummaryItems = items
        request.merchantIdentifier = "merchant.nuha.io.second"
        request.countryCode = "SA"
        request.currencyCode = "SAR"
        request.supportedNetworks = networks
        request.merchantCapabilities = [
            .capability3DS,
            .capabilityCredit,
            .capabilityDebit
        ]
        
        controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller?.delegate = self
        controller?.present(completion: {(p: Bool) in
            print("Presented: " + (p ? "Yes" : "No"))
        })
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        do {
            try applePayService.authorizePayment(request: paymentRequest, token: payment.token) {(result: ApiResult<ApiPayment>) in
                switch (result) {
                case .success(let payment):
                    print("Got payment")
                    print(payment.status)
                    print(payment.id)
                    break;
                case .error(let error):
                    print(error)
                    break;
                }
            }
        } catch {
            print(error)
        }
        
        completion(.success)
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss(completion: {})
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum MyAppStatus {
    case reset
    case success(ApiPayment)
    case failed(Error)
}

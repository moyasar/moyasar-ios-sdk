import SwiftUI
import PassKit

struct ApplePayButton: UIViewRepresentable {
    var action: UIAction
    
    func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(paymentButtonType: .checkout, paymentButtonStyle: .black)
        button.addAction(action, for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: PKPaymentButton, context: Context) {
    }
}

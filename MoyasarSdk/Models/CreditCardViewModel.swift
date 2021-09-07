import Foundation
import SwiftUI

public class CreditCardViewModel: ObservableObject {
    let formatter = CreditCardFormatter()
    let expiryFormatter = ExpiryFormatter()
    var paymentService = PaymentService()
    var paymentRequest: PaymentRequest
    
    @Published var status = CreditCardViewModelStatus.reset
    @Published var nameOnCard = ""
    
    @Published var number = "" {
        didSet {
            let filtered = self.formatter.string(for: number)!
            if number != filtered {
                number = filtered
            }
        }
    }
    
    @Published var expiryDate = "" {
        didSet {
            let filtered = self.expiryFormatter.format(expiryDate)
            if expiryDate != filtered {
                expiryDate = filtered
            }
        }
    }
    
    @Published var securityCode = "" {
        didSet {
            let filtered = String(securityCode.filter { $0.isNumber }.prefix(4))
            if securityCode != filtered {
                securityCode = filtered
            }
        }
    }
    
    var isValid: Bool {
        let validations = [
            nameValidator.validate(value: nameOnCard),
            numberValidator.validate(value: number),
            expiryValidator.validate(value: expiryDate),
            securityCodeValidator.validate(value: securityCode)
        ]
        
        return validations.allSatisfy({ $0 == nil })
    }
    
    lazy var nameValidator = NameOnCardValidator()
    lazy var numberValidator = CardNumberValidator()
    lazy var expiryValidator = ExpiryValidator()
    lazy var securityCodeValidator = SecurityCodeValidator(getNumber: { self.number })
    
    public init(paymentRequest: PaymentRequest) {
        self.paymentRequest = paymentRequest
    }
    
    func beingTransaction() {
        guard isValid else {
            return
        }
        
        guard let expiry = ExpiryDate.fromPattern(expiryDate) else {
            return
        }
        
        let source = ApiCreditCardSource(
            name: nameOnCard,
            number: number.filter { $0.isNumber },
            month: String(expiry.month),
            year: String(expiry.year),
            cvc: securityCode)
        
        let request = ApiPaymentRequest(
            amount: paymentRequest.amount,
            currency: paymentRequest.currency,
            description: paymentRequest.currency,
            callbackUrl: "https://sdk.moyasar.com/return",
            source: ApiPaymentSource.creditCard(source),
            metadata: ["sdk": "ios"])
        
        do {
            try paymentService.create(request, handler: {result in
                print("Got result")
            })
        } catch {
            print("Got error")
        }
    }
}

enum CreditCardViewModelStatus {
    case reset
    case processing
    case paymentAuth
}

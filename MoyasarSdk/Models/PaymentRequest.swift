import Foundation

public struct PaymentRequest {
    public init(amount: Int, currency: String = "SAR", description: String, metadata: [String: String] = [:]) {
        self.amount = amount
        self.currency = currency
        self.description = description
        self.metadata = metadata
    }
    
    var amount: Int
    var currency: String
    var description: String
    var metadata: [String: String]
}

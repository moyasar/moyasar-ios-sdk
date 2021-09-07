import Foundation

public struct PaymentRequest {
    public init(amount: Int, currency: String = "SAR", description: String, apiKey: String, baseUrl: String = "https://api.moyasar.com/") {
        self.amount = amount
        self.currency = currency
        self.description = description
        self.apiKey = apiKey
        self.baseUrl = baseUrl
    }
    
    var amount: Int
    var currency: String
    var description: String
    var apiKey: String
    var baseUrl: String
}

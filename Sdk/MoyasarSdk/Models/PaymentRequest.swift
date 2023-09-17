import Foundation

public struct PaymentRequest {
    public init(
        amount: Int,
        currency: String = "SAR",
        description: String,
        metadata: [String: String] = [:],
        manual: Bool = false,
        saveCard: Bool = false,
        createSaveOnlyToken: Bool = false
    ) {
        self.amount = amount
        self.currency = currency
        self.description = description
        self.metadata = metadata
        self.manual = manual
        self.saveCard = saveCard
        self.createSaveOnlyToken = createSaveOnlyToken
    }
    
    var amount: Int
    var currency: String
    var description: String
    var metadata: [String: String]
    var manual: Bool
    var saveCard: Bool
    var createSaveOnlyToken: Bool
}

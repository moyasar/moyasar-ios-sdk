import Foundation

public struct PaymentRequest {
    public init(
        apiKey: String,
        baseUrl: String = "https://api.moyasar.com",
        amount: Int,
        currency: String = "SAR",
        description: String,
        metadata: [String: String] = [:],
        manual: Bool = false,
        saveCard: Bool = false,
        createSaveOnlyToken: Bool = false,
        allowedNetworks: [CreditCardNetwork] = CreditCardNetwork.allCases
    ) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
        self.amount = amount
        self.currency = currency
        self.description = description
        self.metadata = metadata
        self.manual = manual
        self.saveCard = saveCard
        self.createSaveOnlyToken = createSaveOnlyToken
        self.allowedNetworks = allowedNetworks
    }
    
    public var apiKey: String
    public var baseUrl: String
    public var amount: Int
    public var currency: String
    public var description: String
    public var metadata: [String: String]
    public var manual: Bool
    public var saveCard: Bool
    public var createSaveOnlyToken: Bool
    public var allowedNetworks: [CreditCardNetwork]
}


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
    
    public init(
        apiKey: String,
        amount: Int,
        currency: String = "SAR",
        description: String,
        cashier: String? = nil,
        branch: String? = nil
    ) {
        self.apiKey = apiKey
        self.amount = amount
        self.currency = currency
        self.description = description
        self.cashier = cashier
        self.branch = branch
        
        self.baseUrl = ""
        self.metadata = [:]  // Default value
        self.manual = false  // Default value
        self.saveCard = false  // Default value
        self.createSaveOnlyToken = false  // Default value
        self.allowedNetworks = CreditCardNetwork.allCases  // Default value
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
    public var cashier: String? = nil
    public var branch: String? = nil
}

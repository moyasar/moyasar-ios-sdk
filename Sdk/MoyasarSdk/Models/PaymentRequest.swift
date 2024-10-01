
public struct PaymentRequest {
    public init(
        apiKey: String,
        baseUrl: String = "https://api.moyasar.com",
        amount: Int,
        currency: String = "SAR",
        description: String? = nil,
        metadata: [String: String] = [:],
        manual: Bool = false,
        saveCard: Bool = false,
        createSaveOnlyToken: Bool = false,
        allowedNetworks: [CreditCardNetwork] = [.mada, .visa, .mastercard],
        payButtonType: PayButtonType = .pay
    ) throws {
        if !apiKeyPattern.hasMatch(apiKey) {
            throw MoyasarError.invalidApiKey(apiKey)
        }
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
        self.payButtonType = payButtonType
    }
    
    public var apiKey: String
    public var baseUrl: String
    public var amount: Int
    public var currency: String
    public var description: String?
    public var metadata: [String: String]
    public var manual: Bool
    public var saveCard: Bool
    public var createSaveOnlyToken: Bool
    public var allowedNetworks: [CreditCardNetwork]
    public var cashier: String? = nil
    public var branch: String? = nil
    public var payButtonType: PayButtonType
    
    
    var apiKeyPattern = {
        try! NSRegularExpression(pattern: #"^pk_(test|live)_.{40}$"#, options: [])
    }()
}


public enum PayButtonType {
    case plain
    case pay
    case buy
    case book
    case rent
    case continueType
    case donate
    case topUp
    case order
    case support
    
    var title: String {
        switch self {
        case .plain:
            return ""  // No title
        case .pay:
            return "pay".localized()
        case .buy:
            return "buy".localized()
        case .book:
            return "book".localized()
        case .rent:
            return "rent".localized()
        case .continueType:
            return "continue".localized()
        case .donate:
            return "donate".localized()
        case .topUp:
            return "topUp".localized()
        case .order:
            return "order".localized()
        case .support:
            return "support".localized()
        }
    }
}

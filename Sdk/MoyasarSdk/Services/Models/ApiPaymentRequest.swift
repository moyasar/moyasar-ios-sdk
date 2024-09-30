import Foundation

public struct StcOtpRequest: Codable {
    var otpValue: String
    
    enum CodingKeys: String, CodingKey {
        case otpValue = "otp_value"
    }
}

public struct ApiPaymentRequest: Codable {
    public init(
        publishableApiKey: String? = nil,
        amount: Int,
        currency: String,
        description: String? = nil,
        callbackUrl: String? = nil,
        source: ApiPaymentSource,
        metadata: [String : String]? = nil
    ) {
        self.amount = amount
        self.currency = currency
        self.description = description
        self.callbackUrl = callbackUrl
        self.source = source
        self.metadata = metadata
        self.publishableApiKey = publishableApiKey
    }
    
    public var publishableApiKey: String? /// we send it in STC pay
    public var amount: Int
    public var currency: String
    public var description: String?
    public var callbackUrl: String?
    public var source: ApiPaymentSource
    public var metadata: [String: String]?
 
    enum CodingKeys: String, CodingKey {
        case amount
        case currency
        case description
        case callbackUrl
        case source
        case metadata
        case publishableApiKey = "publishable_api_key"  // Mapping key for publishable_api_key
    }
}

extension ApiPaymentRequest {
    static func from(_ request: PaymentRequest, source: ApiPaymentSource) -> ApiPaymentRequest {
        return ApiPaymentRequest(
            amount: request.amount,
            currency: request.currency,
            description: request.description,
            source: source,
            metadata: request.metadata
        )
    }
}


import Foundation

public struct ApiPaymentRequest: Codable {
    public init(
        amount: Int,
        currency: String,
        description: String,
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
    }
    
    public var amount: Int
    public var currency: String
    public var description: String
    public var callbackUrl: String?
    public var source: ApiPaymentSource
    public var metadata: [String: String]?
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


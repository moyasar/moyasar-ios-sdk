import Foundation

public struct StcOtpRequest: Codable {
    var otpValue: String
    
    enum CodingKeys: String, CodingKey {
        case otpValue = "otp_value"
    }
}

public struct ApiPaymentRequest: Codable {
    public init(
        paymentRequest: PaymentRequest,
        callbackUrl: String? = nil,
        source: ApiPaymentSource
    ) {
        self.amount = paymentRequest.amount
        self.currency = paymentRequest.currency
        self.description = paymentRequest.description
        self.callbackUrl = callbackUrl
        self.source = source
        self.metadata = paymentRequest.metadata
        self.publishableApiKey = paymentRequest.apiKey
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
            paymentRequest: request,
            source: source
        )
    }
}


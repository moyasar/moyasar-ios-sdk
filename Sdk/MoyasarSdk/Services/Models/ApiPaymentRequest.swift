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
        self.givenID = paymentRequest.givenID
        self.applyCoupon = paymentRequest.applyCoupon
    }
    
    public var publishableApiKey: String? /// we send it in STC pay
    public var amount: Int
    public var currency: String
    public var description: String?
    public var callbackUrl: String?
    public var givenID: String?
    public var source: ApiPaymentSource
    public var metadata: [String: MetadataValue]?
    public var applyCoupon: Bool?

    enum CodingKeys: String, CodingKey {
          case publishableApiKey = "publishable_api_key"
          case givenID = "given_id"
          case applyCoupon = "apply_coupon"
          case amount, currency, description, callbackUrl, source, metadata
      }
}

public enum MetadataValue: Codable {
    case stringValue(String)
    case integerValue(Int)
    case floatValue(Float)
    case booleanValue(Bool)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .integerValue(intValue)
        } else if let floatValue = try? container.decode(Float.self) {
            self = .floatValue(floatValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .booleanValue(boolValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .stringValue(stringValue)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid type in MetadataValue")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .stringValue(let value):
            try container.encode(value)
        case .integerValue(let value):
            try container.encode(value)
        case .floatValue(let value):
            try container.encode(value)
        case .booleanValue(let value):
            try container.encode(value)
        }
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


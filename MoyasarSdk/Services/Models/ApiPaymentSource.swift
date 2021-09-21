import Foundation

public enum ApiPaymentSource {
    case creditCard(ApiCreditCardSource)
    case applePay(ApiApplePaySource)
    case stcPay(ApiStcPaySource)
}

extension ApiPaymentSource: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
    }

    private enum SourceType: String, Codable {
        case creditcard
        case applepay
        case stcpay
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let unkeyedContainer = try decoder.singleValueContainer()
        let type = try container.decode(SourceType.self, forKey: .type)
        
        switch type {
        case .creditcard:
            self = .creditCard(try unkeyedContainer.decode(ApiCreditCardSource.self))
        case .applepay:
            self = .applePay(try unkeyedContainer.decode(ApiApplePaySource.self))
        case .stcpay:
            self = .stcPay(try unkeyedContainer.decode(ApiStcPaySource.self))
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .creditCard(let payload):
            try container.encode(payload)
        case .applePay(let payload):
            try container.encode(payload)
        case .stcPay(let payload):
            try container.encode(payload)
        }
    }
}

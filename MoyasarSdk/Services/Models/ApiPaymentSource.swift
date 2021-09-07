import Foundation

enum ApiPaymentSource {
    case creditCard(ApiCreditCardSource)
    case applePay(ApiApplePaySource)
    case stcPay(ApiStcPaySource)
}

extension ApiPaymentSource: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
    }

    private enum SourceType: Int, Codable {
        case creditcard
        case applepay
        case stcpay
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var unkeyedContainer = try decoder.unkeyedContainer()
        let type = try  container.decode(SourceType.self, forKey: .type)
        
        switch type {
        case .creditcard:
            self = .creditCard(try unkeyedContainer.decode(ApiCreditCardSource.self))
        case .applepay:
            self = .applePay(try unkeyedContainer.decode(ApiApplePaySource.self))
        case .stcpay:
            self = .stcPay(try unkeyedContainer.decode(ApiStcPaySource.self))
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        
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

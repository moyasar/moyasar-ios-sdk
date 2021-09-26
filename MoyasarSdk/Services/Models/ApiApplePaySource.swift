import Foundation
import PassKit

public struct ApiApplePaySource: Codable {
    var type: String = "applepay"
    var token: String?
    var company: String?
    var name: String?
    var number: String?
    var message: String?
}

extension ApiApplePaySource {
    static func fromPKToken(_ token: PKPaymentToken) -> ApiApplePaySource {
        return ApiApplePaySource(token: String(data: token.paymentData, encoding: .utf8))
    }
}

struct ApplePayToken: Codable {
    static let decoder = JSONDecoder()
    
    var paymentMethod: ApplePayPaymentMethod
    var paymentInstrumentName: String?
    var paymentNetwork: String?
    var transactionIdentifier: String
    var paymentData: PaymentDataDict
    
    init(token: PKPaymentToken) {
        paymentMethod = ApplePayPaymentMethod(method: token.paymentMethod)
        paymentInstrumentName = token.paymentMethod.displayName
        paymentNetwork = token.paymentMethod.network?.rawValue
        transactionIdentifier = token.transactionIdentifier
        paymentData = try! ApplePayToken.decoder.decode(PaymentDataDict.self, from: token.paymentData)
    }
}

struct ApplePayPaymentMethod: Codable {
    var displayName: String?
    var network: String?
    var type: String
    var paymentPass: ApplePayPaymentPass?
    var billingContact: [String:String]?
    
    init(method: PKPaymentMethod) {
        displayName = method.displayName
        network = method.network?.rawValue
        type = method.type.toString()
        
        if let pass = method.paymentPass {
            paymentPass = ApplePayPaymentPass(pass: pass)
        }
    }
}

struct ApplePayPaymentPass: Codable {
    var primaryAccountIdentifier: String
    var primaryAccountNumberSuffix: String
    var deviceAccountIdentifier: String?
    var deviceAccountNumberSuffix: String?
    var activationState: String
    
    init(pass: PKPaymentPass) {
        primaryAccountIdentifier = pass.primaryAccountIdentifier
        primaryAccountNumberSuffix = pass.primaryAccountNumberSuffix
        deviceAccountIdentifier = pass.deviceAccountIdentifier
        deviceAccountNumberSuffix = pass.deviceAccountNumberSuffix
        activationState = pass.activationState.toString()
    }
}

extension PKPaymentMethodType {
    func toString() -> String {
        switch self {
        case .unknown:
            return "unknown"
        case .debit:
            return "debit"
        case .credit:
            return "credit"
        case .prepaid:
            return "prepaid"
        case .store:
            return "store"
        @unknown default:
            return "unknown"
        }
    }
}

extension PKPaymentPassActivationState {
    func toString() -> String {
        switch self {
        case .activated:
            return "activated"
        case .requiresActivation:
            return "requiresActivation"
        case .activating:
            return "activating"
        case .suspended:
            return "suspended"
        case .deactivated:
            return "deactivated"
        @unknown default:
            return "unknown"
        }
    }
}

public enum PaymentDataValue {
    case string(String?)
    case dict(PaymentDataDict)
}

extension PaymentDataValue: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        do {
            self = .dict(try container.decode(PaymentDataDict.self))
        } catch {
            self = .string(try? container.decode(String.self))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .string(let value):
            try container.encode(value)
        case .dict(let value):
            try container.encode(value)
        }
    }
}

public typealias PaymentDataDict = [String: PaymentDataValue]

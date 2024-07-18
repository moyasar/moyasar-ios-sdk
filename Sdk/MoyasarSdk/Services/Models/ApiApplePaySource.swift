import Foundation
import PassKit

public struct ApiApplePaySource: Codable {
    public init(
        type: String = "applepay",
        token: String? = nil,
        company: String? = nil,
        name: String? = nil,
        number: String? = nil,
        message: String? = nil,
        manual: String? = nil,
        gatewayId: String? = nil,
        referenceNumber: String? = nil,
        responseCode: String? = nil,
        authorizationCode: String? = nil,
        issuerName: String? = nil,
        issuerCountry: String? = nil,
        issuerCardType: String? = nil,
        isserCardCategory: String? = nil
    ) {
        self.type = type
        self.token = token
        self.company = company
        self.name = name
        self.number = number
        self.message = message
        self.manual = manual
        self.gatewayId = gatewayId
        self.referenceNumber = referenceNumber
        self.responseCode = responseCode
        self.authorizationCode = authorizationCode
        self.issuerName = issuerName
        self.issuerCountry = issuerCountry
        self.issuerCardType = issuerCardType
        self.isserCardCategory = isserCardCategory
    }
    
    public var type: String = "applepay"
    public var token: String?
    public var company: String?
    public var name: String?
    public var number: String?
    public var message: String?
    public var manual: String?
    public var gatewayId: String?
    public var referenceNumber: String?
    public var responseCode: String?
    public var authorizationCode: String?
    public var issuerName: String?
    public var issuerCountry: String?
    public var issuerCardType: String?
    public var isserCardCategory: String?
}

extension ApiApplePaySource {
    static public func fromPKToken(_ token: PKPaymentToken) throws -> ApiApplePaySource {
        let encoder = JSONEncoder()
        let data = try encoder.encode(ApplePayToken(token: token))
        
        return ApiApplePaySource(token: String(data: data, encoding: .utf8))
    }
}

public struct ApplePayToken: Codable {
    static let decoder = JSONDecoder()
    
    var paymentMethod: ApplePayPaymentMethod
    var transactionIdentifier: String
    var paymentData: ApplePayPaymentData
    
    init(token: PKPaymentToken) throws {
        paymentMethod = ApplePayPaymentMethod(method: token.paymentMethod)
        transactionIdentifier = token.transactionIdentifier
        
        do {
            paymentData = try ApplePayToken.decoder.decode(ApplePayPaymentData.self, from: token.paymentData)
        } catch {
#if targetEnvironment(simulator)
            print("Apple Pay will not work on a Simulator, test on a real device")
#endif
            throw error
        }
    }
}

public struct ApplePayPaymentMethod: Codable {
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

public struct ApplePayPaymentPass: Codable {
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

struct ApplePayPaymentData: Codable {
    var data: String
    var header: [String: String]
    var signature: String
    var version: String
}

import Foundation

public struct ApiPayment: Codable {
    public var id: String
    public var status: ApiPaymentStatus
    public var amount: Int
    public var amountFormat: String
    public var fee: Int
    public var feeFormat: String?
    public var currency: String
    public var refunded: Int
    public var refundedAt: String?
    public var refundedFormat: String?
    public var captured: Int
    public var capturedAt: String?
    public var capturedFormat: String?
    public var voidedAt: String?
    public var description: String?
    public var invoiceId: String?
    public var ip: String?
    public var callbackUrl: String?
    public var createdAt: String
    public var updatedAt: String
    public var metadata: [String: MetadataValue]?
    public var source: ApiPaymentSource
    
    public func isInitiated() -> Bool {
        return status == .initiated
    }
}

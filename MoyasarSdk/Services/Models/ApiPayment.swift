import Foundation

struct ApiPayment: Codable {
    var id: String
    var status: String
    var amount: Int
    var fee: Int
    var currency: String
    var refunded: Int
    var refundedAt: String?
    var captured: Int
    var capturedAt: String?
    var voidedAt: String?
    var description: String?
    var invoiceId: String?
    var ip: String?
    var callbackUrl: String?
    var createdAt: String
    var updatedAt: String
    var metadata: [String: String]?
    var source: ApiPaymentSource
}

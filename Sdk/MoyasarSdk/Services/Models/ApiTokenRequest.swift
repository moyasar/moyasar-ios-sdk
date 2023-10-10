import Foundation

public struct ApiTokenRequest: Codable {
    var name: String
    var number: String
    var cvc: String?
    var month: String?
    var year: String?
    var saveOnly: Bool = false
    var callbackUrl: String?
    var metadata: [String: String]?
}

extension ApiTokenRequest {
    static func from(_ request: PaymentRequest, source: ApiPaymentSource) throws -> ApiTokenRequest {
        guard case let .creditCard(source) = source else {
            throw NSError(domain: "Argument Error", code: 0)
        }

        return ApiTokenRequest(
            name: source.name,
            number: source.number,
            cvc: source.cvc,
            month: source.month,
            year: source.year,
            saveOnly: true,
            callbackUrl: "https://sdk.moyasar.com/return",
            metadata: request.metadata
        )
    }
}

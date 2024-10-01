import Foundation

public struct ApiTokenRequest: Codable {
    public init(
        name: String,
        number: String,
        cvc: String?,
        month: String?,
        year: String?,
        saveOnly: Bool = false,
        callbackUrl: String?,
        metadata: [String: MetadataValue]? = [:]
    ) {
        self.name = name
        self.number = number
        self.cvc = cvc
        self.month = month
        self.year = year
        self.saveOnly = saveOnly
        self.callbackUrl = callbackUrl
        self.metadata = metadata
    }
    
    public var name: String
    public var number: String
    public var cvc: String?
    public var month: String?
    public var year: String?
    public var saveOnly: Bool = false
    public var callbackUrl: String?
    public var metadata: [String: MetadataValue]?
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

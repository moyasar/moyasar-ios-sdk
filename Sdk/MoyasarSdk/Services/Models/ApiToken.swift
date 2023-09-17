import Foundation

public struct ApiToken: Codable {
    public var id: String
    public var status: String
    public var brand: String
    public var funding: String
    public var country: String
    public var month: String
    public var year: String
    public var name: String
    public var lastFour: String
    public var metadata: [String: String]?
    public var message: String?
    public var verificationUrl: String?
    public var createdAt: String
    public var updatedAt: String
}

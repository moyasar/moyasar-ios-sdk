import Foundation

public struct ApiError: Codable {
    public var message: String?
    public var type: String?
    public var errors: ApiErrorDetail
}

public enum ApiErrorDetail {
    case single(String?)
    case multi(ApiMutliError)
}

extension ApiErrorDetail: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        do {
            self = .multi(try container.decode(ApiMutliError.self))
        } catch {
            self = .single(try? container.decode(String.self))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .single(let error):
            try container.encode(error)
        case .multi(let errors):
            try container.encode(errors)
        }
    }
}

public typealias ApiMutliError = [String: [String]?]?

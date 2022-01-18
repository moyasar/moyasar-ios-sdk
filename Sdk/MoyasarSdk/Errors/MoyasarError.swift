import Foundation

public enum MoyasarError: Error {
    case apiKeyNotSet
    case invalidApiKey(String)
    case networkError(Error)
    case authorizationError(String)
    case apiError(ApiError)
    case unexpectedError(String)
}

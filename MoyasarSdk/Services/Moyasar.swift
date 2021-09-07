import Foundation

struct Moyasar {
    static private var apiKey: String?
    static var baseUrl = "https://api.moyasar.com"
    
    static func setApiKey(_ key: String) throws {
        self.apiKey = key
    }
    
    static func getApiKey() throws -> String {
        guard let apiKey = apiKey else {
            throw MoyasarError.apiKeyNotSet
        }
        return apiKey
    }
}

enum MoyasarError: Error {
    case apiKeyNotSet
    case invalidApiKey(String)
}

import Foundation

public struct Moyasar {
    static private var apiKey: String?
    public static var baseUrl = "https://api.moyasar.com"
    
    private static var apiKeyPattern = {
        try! NSRegularExpression(pattern: #"^pk_(test|live)_.{40}$"#, options: [])
    }()
    
    public static func setApiKey(_ key: String) throws {
        if (!apiKeyPattern.hasMatch(key)) {
            throw MoyasarError.invalidApiKey(key)
        }
        self.apiKey = key
    }
    
    static func getApiKey() throws -> String {
        guard let apiKey = apiKey else {
            throw MoyasarError.apiKeyNotSet
        }
        return apiKey
    }
}

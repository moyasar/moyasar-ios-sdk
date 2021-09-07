import Foundation

struct ApiError: Codable {
    var message: String?
    var type: String?
    var errors: String
}

enum ApiErrorDetail {
    case single(String)
    case multi([String: [String]?]?)
}

//extension ApiErrorDetail: Codable {
//    init(from decoder: Decoder) throws {
//        <#code#>
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        <#code#>
//    }
//}

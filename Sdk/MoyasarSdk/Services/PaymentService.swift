import Foundation

final public class PaymentService {
    
    let baseUrl: String
    let apiKey: String
    
    var session = URLSession.shared

    var encoder: JSONEncoder = {
        let enc = JSONEncoder()
        enc.keyEncodingStrategy = .convertToSnakeCase
        return enc
    }()
    var decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        return dec
    }()
    
    var createUrl: URL {
        return URL(string: baseUrl + (baseUrl.last == "/" ? "" : "/") + "v1/payments")!
    }
    var createTokenUrl: URL {
        return URL(string: baseUrl + (baseUrl.last == "/" ? "" : "/") + "v1/tokens")!
    }
    
    private var apiKeyPattern = {
        try! NSRegularExpression(pattern: #"^pk_(test|live)_.{40}$"#, options: [])
    }()
    
    public init(baseUrl: String = "https://api.moyasar.com", apiKey: String) {
        self.baseUrl = baseUrl
        
        if (!apiKeyPattern.hasMatch(apiKey)) {
            print("Moyasar SDK error: Invalid API key, \(MoyasarError.invalidApiKey(apiKey))")
        }
        
        self.apiKey = apiKey
    }
    
    public func create(_ paymentRequest: ApiPaymentRequest, handler: @escaping ApiResultHandler<ApiPayment>) throws {
        let payload = try encoder.encode(paymentRequest)
        var request = URLRequest(url: createUrl)
        let auth = "\(apiKey):".data(using: .utf8)?.base64EncodedString()
        
        request.setValue("Basic \(auth!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("moyasar-ios-sdk", forHTTPHeaderField: "X-MOYASAR-LIB")
        request.httpMethod = "POST"
        request.httpBody = payload
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                let error = MoyasarError.unexpectedError("Request failed: \(error.localizedDescription)")
                handler(ApiResult.error(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                let error = MoyasarError.unexpectedError("Invalid response type")
                handler(ApiResult.error(error))
                return
            }
            
            guard let data = data else {
                let error = MoyasarError.unexpectedError("No data returned from API")
                handler(ApiResult.error(error))
                return
            }
            
            guard 200...299 ~= response.statusCode else {
                do {
                    let apiError = try self.decoder.decode(ApiError.self, from: data)
                    let error = MoyasarError.apiError(apiError)
                    handler(ApiResult.error(error))
                } catch {
                    let error = MoyasarError.unexpectedError("Decoding API's error data failed: \(error.localizedDescription)")
                    handler(ApiResult.error(error))
                }
                return
            }
            
            do {
                let payment = try self.decoder.decode(ApiPayment.self, from: data)
                handler(ApiResult.success(payment))
            } catch {
                let error = MoyasarError.unexpectedError("Decoding API's payment data failed: \(error.localizedDescription)")
                handler(ApiResult.error(error))
            }
        }
        
        task.resume()
    }
    
    public func createToken(_ tokenRequest: ApiTokenRequest, handler: @escaping ApiResultHandler<ApiToken>) throws {
        let payload = try encoder.encode(tokenRequest)
        var request = URLRequest(url: createTokenUrl)
        let auth = "\(apiKey):".data(using: .utf8)?.base64EncodedString()
        
        request.setValue("Basic \(auth!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("moyasar-ios-sdk", forHTTPHeaderField: "X-MOYASAR-LIB")
        request.httpMethod = "POST"
        request.httpBody = payload
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                let error = MoyasarError.unexpectedError("Request failed: \(error.localizedDescription)")
                handler(ApiResult.error(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                let error = MoyasarError.unexpectedError("Invalid response type")
                handler(ApiResult.error(error))
                return
            }
            
            guard let data = data else {
                let error = MoyasarError.unexpectedError("No data returned from API")
                handler(ApiResult.error(error))
                return
            }
            
            guard 200...299 ~= response.statusCode else {
                do {
                    let apiError = try self.decoder.decode(ApiError.self, from: data)
                    let error = MoyasarError.apiError(apiError)
                    handler(ApiResult.error(error))
                } catch {
                    let error = MoyasarError.unexpectedError("Decoding API's error data failed: \(error.localizedDescription)")
                    handler(ApiResult.error(error))
                }
                return
            }
            
            do {
                let payment = try self.decoder.decode(ApiToken.self, from: data)
                handler(ApiResult.success(payment))
            } catch {
                let error = MoyasarError.unexpectedError("Decoding API's payment data failed: \(error.localizedDescription)")
                handler(ApiResult.error(error))
            }
        }
        
        task.resume()
    }
}

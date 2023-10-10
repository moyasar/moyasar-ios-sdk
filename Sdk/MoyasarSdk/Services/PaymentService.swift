import Foundation

final public class PaymentService {
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
        let baseUrl = Moyasar.baseUrl
        return URL(string: baseUrl + (baseUrl.last == "/" ? "" : "/") + "v1/payments")!
    }
    
    var createTokenUrl: URL {
        let baseUrl = Moyasar.baseUrl
        return URL(string: baseUrl + (baseUrl.last == "/" ? "" : "/") + "v1/tokens")!
    }
    
    public func create(_ paymentRequest: ApiPaymentRequest, handler: @escaping ApiResultHandler<ApiPayment>) throws {
        let apiKey = try Moyasar.getApiKey()
        let payload = try encoder.encode(paymentRequest)
        var request = URLRequest(url: createUrl)
        let auth = "\(apiKey):".data(using: .utf8)?.base64EncodedString()
        
        request.setValue("Basic \(auth!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("moyasar-ios-sdk", forHTTPHeaderField: "X-MOYASAR-LIB")
        request.httpMethod = "POST"
        request.httpBody = payload
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                handler(ApiResult.error(error!))
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
                    handler(ApiResult.error(error))
                }
                return
            }
            
            do {
                let payment = try self.decoder.decode(ApiPayment.self, from: data)
                handler(ApiResult.success(payment))
            } catch {
                handler(ApiResult.error(error))
            }
        }
        
        task.resume()
    }
    
    public func createToken(_ tokenRequest: ApiTokenRequest, handler: @escaping ApiResultHandler<ApiToken>) throws {
        let apiKey = try Moyasar.getApiKey()
        let payload = try encoder.encode(tokenRequest)
        var request = URLRequest(url: createTokenUrl)
        let auth = "\(apiKey):".data(using: .utf8)?.base64EncodedString()
        
        request.setValue("Basic \(auth!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("moyasar-ios-sdk", forHTTPHeaderField: "X-MOYASAR-LIB")
        request.httpMethod = "POST"
        request.httpBody = payload
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                handler(ApiResult.error(error!))
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
                    handler(ApiResult.error(error))
                }
                return
            }
            
            do {
                let payment = try self.decoder.decode(ApiToken.self, from: data)
                handler(ApiResult.success(payment))
            } catch {
                handler(ApiResult.error(error))
            }
        }
        
        task.resume()
    }
}

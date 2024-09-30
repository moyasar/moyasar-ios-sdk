//
//  PaymentServices.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 11/06/2024.
//

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
    
    var apiKeyPattern = {
        try! NSRegularExpression(pattern: #"^pk_(test|live)_.{40}$"#, options: [])
    }()
    
    public init(apiKey: String, baseUrl: String = "https://api.moyasar.com") throws {
        self.baseUrl = baseUrl
        
        if !apiKeyPattern.hasMatch(apiKey) {
            throw MoyasarError.invalidApiKey(apiKey)
        }
        
        self.apiKey = apiKey
    }
    
    private var createUrl: URL {
        return URL(string: baseUrl + (baseUrl.last == "/" ? "" : "/") + "v1/payments")!
    }
    
    private var createTokenUrl: URL {
        return URL(string: baseUrl + (baseUrl.last == "/" ? "" : "/") + "v1/tokens")!
    }
    
    private func makeRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw MoyasarError.unexpectedError("Invalid response type")
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let apiError = try decoder.decode(ApiError.self, from: data)
                throw MoyasarError.apiError(apiError)
            }
            
            return try decoder.decode(T.self, from: data)
        } catch let error as MoyasarError {
            throw error
        } catch {
            throw MoyasarError.unexpectedError("Request failed: \(error.localizedDescription)")
        }
    }
    
    public func createPayment(_ paymentRequest: ApiPaymentRequest) async throws -> ApiPayment {
        let payload = try encoder.encode(paymentRequest)
        let request = createPaymentRequest(payload: payload, url: createUrl)
        return try await makeRequest(request)
    }
    
    public func createToken(_ tokenRequest: ApiTokenRequest) async throws -> ApiToken {
        let payload = try encoder.encode(tokenRequest)
        let request = createPaymentRequest(payload: payload, url: createTokenUrl)
        return try await makeRequest(request)
    }
    
    private func createPaymentRequest(payload: Data, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        let auth = "\(apiKey):".data(using: .utf8)?.base64EncodedString()
        request.setValue("Basic \(auth!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("moyasar-ios-sdk", forHTTPHeaderField: "X-MOYASAR-LIB")
        if let sdkVersion = Bundle(for: PaymentService.self).infoDictionary?["CFBundleShortVersionString"] as? String {
            request.addValue(sdkVersion, forHTTPHeaderField: "SDK-Version")
        }
        request.httpMethod = "POST"
        request.httpBody = payload
        return request
    }
    
    public func sendSTCPaymentRequest(url: URL, stcOtpRequest: StcOtpRequest) async throws -> ApiPayment {
        let payload = try encoder.encode(stcOtpRequest)
        let request = createStcPaymentRequest(payload: payload, url: url)
        return try await makeRequest(request)
    }
    
    private func createStcPaymentRequest(payload: Data, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("moyasar-ios-sdk", forHTTPHeaderField: "X-MOYASAR-LIB")
        if let sdkVersion = Bundle(for: PaymentService.self).infoDictionary?["CFBundleVersion"] as? String {
            request.addValue(sdkVersion, forHTTPHeaderField: "SDK-Version")
        }
        request.httpMethod = "POST"
        request.httpBody = payload
        return request
    }
}

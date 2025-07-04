//
//  ApplePayService.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 11/06/2024.
//

import Foundation
import PassKit

public final class ApplePayService {
    
    private let apiKey: String
    private let paymentService: PaymentService
    
    public init(apiKey: String, baseUrl: String = "https://api.moyasar.com") throws {
        self.apiKey = apiKey
        paymentService =  PaymentService(apiKey: apiKey, baseUrl: baseUrl)
    }
    
    public func authorizePayment(request: PaymentRequest, token: PKPaymentToken) async throws -> ApiPayment {
        do {
            var applePaySource = try ApiApplePaySource.fromPKToken(token)
            applePaySource.manual = request.manual ? "true" : "false"
            applePaySource.saveCard = request.saveCard 
            let source = ApiPaymentSource.applePay(applePaySource)
            let apiRequest = ApiPaymentRequest.from(request, source: source)
            
            return try await paymentService.createPayment(apiRequest)
        } catch {
            throw error
        }
    }
}

import Foundation
import PassKit

public final class ApplePayService {
    
    private let apiKey: String
    private let paymentService: PaymentService
    
    public init(apiKey: String) {
        self.apiKey = apiKey
        self.paymentService = PaymentService(apiKey: apiKey)
    }
    
    public func authorizePayment(request: PaymentRequest, token: PKPaymentToken, handler: @escaping ApiResultHandler<ApiPayment>) throws {
        var applePaySource = try ApiApplePaySource.fromPKToken(token)
        applePaySource.manual = request.manual ? "true" : "false"
        
        let source = ApiPaymentSource.applePay(applePaySource)
        let apiRequest = ApiPaymentRequest.from(request, source: source)
        
        try paymentService.create(apiRequest, handler: handler)
    }
}

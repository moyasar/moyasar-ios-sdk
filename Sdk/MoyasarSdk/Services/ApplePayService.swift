import Foundation
import PassKit

public final class ApplePayService {
    let paymentService = PaymentService()
    let encoder = JSONEncoder()
    
    public init() {}
    
    public func authorizePayment(request: PaymentRequest, token: PKPaymentToken, handler: @escaping ApiResultHandler<ApiPayment>) throws {
        var applePaySource = ApiApplePaySource.fromPKToken(token)
        applePaySource.manual = request.manual ? "true" : "false"
        
        let source = ApiPaymentSource.applePay(applePaySource)
        let apiRequest = ApiPaymentRequest.from(request, source: source)
        
        try paymentService.create(apiRequest, handler: handler)
    }
}

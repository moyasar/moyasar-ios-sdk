import Foundation

public enum PaymentResult {
    case completed(ApiPayment)
    case saveOnlyToken(ApiToken)
    case failed(MoyasarError)
    case canceled
}


public enum STCPaymentResult {
    case completed(ApiPayment)
    case failed(MoyasarError)
}

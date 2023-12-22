import Foundation

public enum PaymentResult {
    case completed(ApiPayment)
    case saveOnlyToken(ApiToken)
    case failed(MoyasarError)
    case canceled
}

import XCTest
@testable import MoyasarSdk

class ApiPaymentTests: XCTestCase {
    var decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        return dec
    }()
    
    func testDecodeSuccessfully() {
        let payment = try! self.decoder.decode(ApiPayment.self, from: testPayment)
        XCTAssertEqual(ApiPaymentStatus.initiated, payment.status)
        if case .stringValue(let sdkValue) = payment.metadata!["sdk"] {
            XCTAssertEqual(sdkValue, "ios")
        } else {
            XCTFail("Expected stringValue for sdk but got something else.")
        }
        
        guard case let .creditCard(source) = payment.source else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual("Ali Alhoshaiyan", source.name)
    }
    
    var testPayment: Data {
        "{\"id\":\"002e9cb3-52a5-4022-8e68-4c956fb98277\",\"status\":\"initiated\",\"amount\":100,\"fee\":0,\"currency\":\"SAR\",\"refunded\":0,\"refunded_at\":null,\"captured\":0,\"captured_at\":null,\"voided_at\":null,\"description\":\"SAR\",\"amount_format\":\"1.00 SAR\",\"fee_format\":\"0.00 SAR\",\"refunded_format\":\"0.00 SAR\",\"captured_format\":\"0.00 SAR\",\"invoice_id\":null,\"ip\":null,\"callback_url\":\"https://sdk.moyasar.com/return\",\"created_at\":\"2021-09-19T17:39:29.712Z\",\"updated_at\":\"2021-09-19T17:39:29.712Z\",\"metadata\":{\"sdk\":\"ios\",\"order_id\":\"ios_order_3214124\"},\"source\":{\"type\":\"creditcard\",\"company\":\"visa\",\"name\":\"Ali Alhoshaiyan\",\"number\":\"XXXX-XXXX-XXXX-1111\",\"message\":null,\"transaction_url\":\"https://api.moyasar.com/v1/transaction_auths/e9874be0-be2c-4ba8-8a6a-abf810234635/form?token=auth_ZWbuvSsaVpXgnHjGCZt3FGBkVyaWzbs6qrjZQfLxYqQ\"}}".data(using: .utf8)!
    }
}

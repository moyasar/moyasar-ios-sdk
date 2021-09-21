import XCTest
@testable import MoyasarSdk

class PaymentSourceTests: XCTestCase {
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
    
    var ccSource: ApiCreditCardSource {
        ApiCreditCardSource(name: "John Doe", number: "4111111111111111", month: "09", year: "25", cvc: "456")
    }
    
    func testCanSeriallizeCreditCardSource() {
        let source = ApiPaymentSource.creditCard(ccSource)
        let data = try! encoder.encode(source)
        let json = String(data: data, encoding: .utf8)!
        
        print(json)
        XCTAssert(json.contains("creditcard"))
        XCTAssert(json.contains("John Doe"))
        XCTAssert(json.contains("4111111111111111"))
        XCTAssert(json.contains("09"))
        XCTAssert(json.contains("25"))
        XCTAssert(json.contains("456"))
    }
    
    func testCanParseCreditCardSource() {
        let data = "{\"year\":\"25\",\"number\":\"4111111111111111\",\"cvc\":\"456\",\"type\":\"creditcard\",\"name\":\"John Doe\",\"month\":\"09\"}".data(using: .utf8)!
        
        let source = try! decoder.decode(ApiPaymentSource.self, from: data)
        
        guard case let .creditCard(cc) = source else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual(cc.name, "John Doe")
        XCTAssertEqual(cc.number, "4111111111111111")
        XCTAssertEqual(cc.month, "09")
        XCTAssertEqual(cc.year, "25")
        XCTAssertEqual(cc.cvc, "456")
    }
}

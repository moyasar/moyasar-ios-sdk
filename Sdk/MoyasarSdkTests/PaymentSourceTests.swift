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
    
    // MARK: - UnionPay Tests
    
    func testUnionPayCardDetection() {
        let testCases = [
            ("6221260000000000000", .unionpay),      // 19-digit UnionPay
            ("622126123456789", .unionpay),         // 15-digit UnionPay
            ("6221261234567890", .unionpay),        // 16-digit UnionPay
            ("6229123456789012", .unionpay),        // 16-digit UnionPay
            ("6282123456789012", .unionpay),        // 16-digit UnionPay
            ("6241234567890123", .unionpay),        // 16-digit UnionPay
            ("6251234567890123", .unionpay),        // 16-digit UnionPay
            ("6261234567890123", .unionpay),        // 16-digit UnionPay
            ("4111111111111111", .visa),            // Visa card
            ("5555555555554444", .mastercard),      // Mastercard
            ("371122334455666", .amex),            // Amex card
            ("6011111111111117", .unknown),        // Unknown card (Discover)
            ("1234567890123456", .unknown)          // Unknown card
        ]
        
        for (cardNumber, expectedNetwork) in testCases {
            let network = getCardNetwork(cardNumber, in: [.visa, .mastercard, .amex, .unionpay])
            XCTAssertEqual(network, expectedNetwork, "Failed to detect \(expectedNetwork) for card: \(cardNumber)")
        }
    }
    
    func testUnionPayCardFormatting() {
        let formatter = CreditCardFormatter()
        
        let testCases = [
            ("6221260000000000000", "6221 2600 0000 0000 000"),  // 19-digit UnionPay
            ("622126123456789", "6221 2612 3456 789"),          // 15-digit UnionPay
            ("6221261234567890", "6221 2612 3456 7890"),        // 16-digit UnionPay
            ("4111111111111111", "4111 1111 1111 1111"),        // Visa card
            ("5555555555554444", "5555 5555 5555 4444"),        // Mastercard
            ("371122334455666", "3711 223344 55666")            // Amex card
        ]
        
        for (input, expected) in testCases {
            let formatted = formatter.formatCardNumber(input)
            XCTAssertEqual(formatted, expected, "Failed to format \(input) correctly")
        }
    }
    
    func testUnionPayLuhnValidation() {
        let validUnionPayCards = [
            "6221260000000000000",  // 19-digit valid UnionPay
            "6221261234567890",     // 16-digit valid UnionPay
        ]
        
        let invalidUnionPayCards = [
            "6221260000000000001",  // Invalid Luhn
            "6221261234567891",     // Invalid Luhn
        ]
        
        for card in validUnionPayCards {
            XCTAssertTrue(isValidLuhnNumber(card), "\(card) should be valid")
        }
        
        for card in invalidUnionPayCards {
            XCTAssertFalse(isValidLuhnNumber(card), "\(card) should be invalid")
        }
    }
}
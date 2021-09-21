import XCTest
@testable import MoyasarSdk

class ApiErrorTests: XCTestCase {
    var decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        return dec
    }()
    
    func testCanDeserializeStringErrors() {
        let testCase = "{\"message\":\"Hello Errors World!\",\"type\":\"invalid_stuff_error\",\"errors\":\"Single message error\"}".data(using: .utf8)!
        
        let apiError = try! self.decoder.decode(ApiError.self, from: testCase)
        guard case let .single(error) = apiError.errors else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual("Single message error", error)
    }
    
    func testCanDeserializeObjectErrors() {
        let testCase = "{\"message\":\"Hello Errors World!\",\"type\":\"invalid_stuff_error\",\"errors\":{\"field1\":[\"error1\",\"error2\"]}}".data(using: .utf8)!
        
        let apiError = try! self.decoder.decode(ApiError.self, from: testCase)
        guard case let .multi(errors) = apiError.errors else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual(["field1": [
            "error1",
            "error2"
        ]], errors)
    }
}

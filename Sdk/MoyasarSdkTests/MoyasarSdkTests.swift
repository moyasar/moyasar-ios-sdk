//
//  MoyasarSdkTests.swift
//  MoyasarSdkTests
//
//  Created by Ali Alhoshaiyan on 04/09/2021.
//

import XCTest
@testable import MoyasarSdk

class MoyasarSdkTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLuhnValidatorSucceedWithCorrectNumber() throws {
        XCTAssert(isValidLuhnNumber("4111 1111 1111 1111"))
    }
    
    func testLuhnValidatorFailsWithInvalidNumber() throws {
        XCTAssertFalse(isValidLuhnNumber("4111 1111 1111 1112"))
    }
    
    func testExpiryDateParsesFourDigitExpiry() throws {
        let expiry = ExpiryDate.fromPattern("09 / 25")
        
        XCTAssertNotNil(expiry)
        XCTAssertEqual(expiry?.month, 9)
        
        let millennium = (ExpiryDate.cal.dateComponents([.year], from: Date()).year! / 100) * 100
        XCTAssertEqual(expiry?.year, 25 + millennium)
        
        XCTAssertTrue(expiry?.isValid() ?? false)
    }
    
    func testExpiryDateParsesSixDigitExpiry() throws {
        let expiry = ExpiryDate.fromPattern("09 / 2019")
        
        XCTAssertNotNil(expiry)
        XCTAssertEqual(expiry?.month, 9)
        XCTAssertEqual(expiry?.year, 2019)
        XCTAssertTrue(expiry?.isValid() ?? false)
        XCTAssertTrue(expiry?.expired() ?? false)
    }
}

//
//  STCValidatorTests.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 29/09/2024.
//

import XCTest
@testable import MoyasarSdk

class STCValidatorTests: XCTestCase {
    var validator: STCValidator!

    override func setUp() {
        super.setUp()
        validator = STCValidator()
    }

    override func tearDown() {
        validator = nil
        super.tearDown()
    }

    func testValidSaudiPhoneNumber() {
        let validPhoneNumber = "0555123456"
        XCTAssertTrue(validator.isValidSaudiPhoneNumber(validPhoneNumber), "The phone number should be valid")
    }

    func testInvalidSaudiPhoneNumber() {
        let invalidPhoneNumber = "123456789"
        XCTAssertFalse(validator.isValidSaudiPhoneNumber(invalidPhoneNumber), "The phone number should be invalid")
    }

    func testValidOtp() {
        let validOtp = "1234"
        XCTAssertTrue(validator.isValidOtp(validOtp), "The OTP should be valid")
    }

    func testInvalidOtp() {
        let invalidOtp = "12345678910"
        XCTAssertFalse(validator.isValidOtp(invalidOtp), "The OTP should be invalid")
    }
}

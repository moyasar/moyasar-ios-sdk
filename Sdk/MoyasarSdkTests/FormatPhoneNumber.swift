//
//  FormatPhoneNumber.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 30/09/2024.
//

import XCTest
@testable import MoyasarSdk

final class PhoneNumberFormatterTests: XCTestCase {
    var formatter: PhoneNumberFormatter!

    override func setUp() {
        super.setUp()
        formatter = PhoneNumberFormatter()
    }

    override func tearDown() {
        formatter = nil
        super.tearDown()
    }

    func testFormatPhoneNumber_withValidNumber() {
        let formattedNumber = formatter.formatPhoneNumber("0551234567")
        XCTAssertEqual(formattedNumber, "055 123 4567", "Phone number formatting is incorrect")
    }

    func testFormatPhoneNumber_withShortNumber() {
        let formattedNumber = formatter.formatPhoneNumber("05512")
        XCTAssertEqual(formattedNumber, "055 12", "Short phone number formatting is incorrect")
    }

    func testFormatPhoneNumber_withEmptyNumber() {
        let formattedNumber = formatter.formatPhoneNumber("")
        XCTAssertEqual(formattedNumber, "", "Empty phone number formatting should return an empty string")
    }

    func testFormatPhoneNumber_withTooLongNumber() {
        let formattedNumber = formatter.formatPhoneNumber("055123456789")
        XCTAssertEqual(formattedNumber, "055 123 4567", "Phone number should be truncated to fit 3-3-4 format")
    }
    
    func testValidPhoneNumberFormatting() {
        let formattedNumber = formatter.formatPhoneNumber("0551234567")
        let expectedNumberCount = 12
        XCTAssertEqual(formattedNumber.count, expectedNumberCount)
    }
}

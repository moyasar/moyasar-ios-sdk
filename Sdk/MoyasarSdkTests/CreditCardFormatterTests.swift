//
//  CreditCardFormatterTests.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 21/05/2026.
//

import XCTest
@testable import MoyasarSdk

final class CreditCardFormatterTests: XCTestCase {
    private var formatter: CreditCardFormatter!

    override func setUp() {
        super.setUp()
        formatter = CreditCardFormatter()
    }

    override func tearDown() {
        formatter = nil
        super.tearDown()
    }

    func testFormatCardNumber_standardCardsGroupedAndTruncatedAt16Digits() {
        XCTAssertEqual(formatter.formatCardNumber("4111111111111111"), "4111 1111 1111 1111")
        XCTAssertEqual(formatter.formatCardNumber("41111111111111112222"), "4111 1111 1111 1111")
    }

    func testFormatCardNumber_amexUses4_6_5Pattern() {
        XCTAssertEqual(formatter.formatCardNumber("371122334455666"), "3711 223344 55666")
        XCTAssertEqual(formatter.formatCardNumber("3711223"), "3711 223")
    }

    func testFormatCardNumber_unionPaySupportsUpTo19Digits() {
        XCTAssertEqual(formatter.formatCardNumber("6200000000000005"), "6200 0000 0000 0005")
        XCTAssertEqual(formatter.formatCardNumber("6200000000000000007"), "6200 0000 0000 0000 007")
    }

    func testFormatCardNumber_unionPayBeyond19DigitsFallsBackToStandardPath() {
        XCTAssertEqual(formatter.formatCardNumber("62000000000000000000"), "6200 0000 0000 0000")
    }

    func testFormatCardNumber_normalizesArabicDigitsAndNonDigitCharacters() {
        XCTAssertEqual(formatter.formatCardNumber("٤١١١-١١١١ ١١١١ ١١١١"), "4111 1111 1111 1111")
    }

    func testFormatExpiryDate_limitsTo6DigitsAndFormatsAfterMonth() {
        XCTAssertEqual(formatter.formatExpiryDate("12"), "12")
        XCTAssertEqual(formatter.formatExpiryDate("1225"), "12 / 25")
        XCTAssertEqual(formatter.formatExpiryDate("1234567"), "12 / 3456")
    }

    func testFormatExpiryDate_normalizesArabicDigitsAndRemovesNonDigits() {
        XCTAssertEqual(formatter.formatExpiryDate("١٢2a5"), "12 / 25")
    }

    func testFormatCVC_respectsNetworkLengthAndNormalizesInput() {
        XCTAssertEqual(formatter.formatCVC("12345", forCardNumber: "3711 223344 55666"), "1234")
        XCTAssertEqual(formatter.formatCVC("12345", forCardNumber: "4111 1111 1111 1111"), "123")
        XCTAssertEqual(formatter.formatCVC("١٢٣٤٥", forCardNumber: "371122334455666"), "1234")
    }
}

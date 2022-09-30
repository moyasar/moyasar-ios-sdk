//
//  ExpiryValidatorTests.swift
//  MoyasarSdkTests
//
//  Created by Ali Alhoshaiyan on 30/09/2022.
//

import XCTest
@testable import MoyasarSdk

final class ExpiryDateTests: XCTestCase {
    func testExample() throws {
        let year = Calendar.current.dateComponents([.year], from: Date()).year!
        let yearShort = String(year).substringByInt(start: 2, length: 2)
        
        let futureYear = year + Int.random(in: 1...5)
        let pastYear = year - Int.random(in: 2...2)
        
        
        XCTAssert(ExpiryDate.fromPattern("01 / \(year)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("02 / \(year)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("03 / \(year)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("04 / \(year)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("05 / \(year)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("06 / \(year)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("07 / \(year)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("08 / \(year)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("09 / \(year)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("10 / \(year)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("11 / \(year)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("12 / \(year)")!.isValid())
        
        XCTAssert(ExpiryDate.fromPattern("01 / \(futureYear)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("02 / \(futureYear)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("03 / \(futureYear)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("04 / \(futureYear)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("05 / \(futureYear)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("06 / \(futureYear)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("07 / \(futureYear)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("08 / \(futureYear)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("09 / \(futureYear)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("10 / \(futureYear)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("11 / \(futureYear)")!.isValid())
        XCTAssert(ExpiryDate.fromPattern("12 / \(futureYear)")!.isValid())
        
        XCTAssert(ExpiryDate.fromPattern("01 / \(pastYear)")!.expired())
        XCTAssert(ExpiryDate.fromPattern("02 / \(pastYear)")!.expired())
        XCTAssert(ExpiryDate.fromPattern("03 / \(pastYear)")!.expired())
        XCTAssert(ExpiryDate.fromPattern("04 / \(pastYear)")!.expired())
        XCTAssert(ExpiryDate.fromPattern("05 / \(pastYear)")!.expired())
        XCTAssert(ExpiryDate.fromPattern("06 / \(pastYear)")!.expired())
        XCTAssert(ExpiryDate.fromPattern("07 / \(pastYear)")!.expired())
        XCTAssert(ExpiryDate.fromPattern("08 / \(pastYear)")!.expired())
        XCTAssert(ExpiryDate.fromPattern("09 / \(pastYear)")!.expired())
        XCTAssert(ExpiryDate.fromPattern("10 / \(pastYear)")!.expired())
        XCTAssert(ExpiryDate.fromPattern("11 / \(pastYear)")!.expired())
        XCTAssert(ExpiryDate.fromPattern("12 / \(pastYear)")!.expired())
    }
}

//
//  CreditCardUtil.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 27/08/2021.
//

import Foundation

var amexRangeRegex = try! NSRegularExpression(pattern: #"^3[47]"#, options: [])
var visaRangeRegex = try! NSRegularExpression(pattern: #"^4"#, options: [])
var masterCardRangeRegex = try! NSRegularExpression(pattern: #"^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)"#, options: [])

func isValidLuhnNumber(_ number: String) -> Bool {
    let clean = number.replacingOccurrences(of: " ", with: "")
    guard var sum = clean.last?.wholeNumberValue else {
        return false
    }
    
    for index in 0..<clean.count - 1 {
        let valueIndex = clean.index(clean.startIndex, offsetBy: index)
        guard var value = clean[valueIndex].wholeNumberValue else {
            return false
        }
        
        if (index % 2 == 0) {
            value *= 2
        }
        if (value > 9) {
            value -= 9
        }
        
        sum += value
    }
    
    return sum % 10 == 0
}

func getCardNetwork(_ number: String) -> CreditCardNetwork {
    let clean = number.replacingOccurrences(of: " ", with: "")
    
    if amexRangeRegex.hasMatch(clean) {
        return .amex
    } else if MadaUtil.instance.inMadaRange(clean) {
        return .mada
    } else if visaRangeRegex.hasMatch(clean) {
        return .visa
    } else if masterCardRangeRegex.hasMatch(clean) {
        return .mastercard
    } else {
        return .unknown
    }
}

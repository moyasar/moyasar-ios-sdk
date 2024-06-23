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

func getCardNetwork(_ number: String, in supportedNetworks: [CreditCardNetwork]) -> CreditCardNetwork {
    let clean = number.replacingOccurrences(of: " ", with: "")
    
    // Check if the number matches known card types and if it's in supported networks
       if amexRangeRegex.hasMatch(clean) && supportedNetworks.contains(.amex){
           return .amex
       } else if MadaUtil.instance.inMadaRange(clean) && supportedNetworks.contains(.mada) {
           /// Here if the supported network is not mada but the user choosed master or visa in supported network we never block him
           return .mada
       } else if visaRangeRegex.hasMatch(clean) && supportedNetworks.contains(.visa)  {
           return .visa
       } else if masterCardRangeRegex.hasMatch(clean) && supportedNetworks.contains(.mastercard) {
           return .mastercard 
       } else {
           return .unknown
       }
}

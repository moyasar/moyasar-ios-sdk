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
    let cleanNumber = number.replacingOccurrences(of: " ", with: "")
    guard cleanNumber.isNumeric else {
        return false
    }
    
    let doubleSum = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]
    var sum = 0
    
    for (index, character) in cleanNumber.reversed().enumerated() {
        guard let digit = character.wholeNumberValue else {
            return false
        }
        sum += index % 2 == 0 ? digit : doubleSum[digit]
    }
    
    return sum % 10 == 0
}

extension String {
    var isNumeric: Bool {
        return !isEmpty && range(of: "\\D", options: .regularExpression) == nil
    }
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

//
//  CardNumberValidator.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 31/08/2021.
//

import Foundation

class CardNumberValidator: FieldValidator {
    override init() {
        super.init()
        addRule(error: "Card number is required") {
            ($0 ?? "").isEmpty
        }
        addRule(error: "Invalid card number") {
            ($0 ?? "").count < 16 || !isValidLuhnNumber($0 ?? "")
        }
        addRule(error: "Unsupported network") {
            getCardNetwork($0 ?? "") == .unknown
        }
    }
}

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
        addRule(error: "card-number-required".localized()) {
            ($0 ?? "").isEmpty
        }
        addRule(error: "invalid-card-number".localized()) {
            ($0 ?? "").count < 16 || !isValidLuhnNumber($0 ?? "")
        }
        addRule(error: "unsupported-network".localized()) {
            getCardNetwork($0 ?? "") == .unknown
        }
    }
}

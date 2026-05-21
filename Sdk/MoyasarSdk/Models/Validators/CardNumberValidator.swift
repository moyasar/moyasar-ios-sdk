//
//  CardNumberValidator.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 31/08/2021.
//

import Foundation

class CardNumberValidator: FieldValidator {
    private var supportedNetworks: [CreditCardNetwork]

    init(supportedNetworks: [CreditCardNetwork]) {
        self.supportedNetworks = supportedNetworks
        super.init()
        addRule(error: "card-number-required".localized()) {
            ($0 ?? "").isEmpty
        }
        addRule(error: "invalid-card-number".localized()) {
            let network = getCardNetwork($0 ?? "", in: self.supportedNetworks)
            if network == .unionpay {
                let clean = ($0 ?? "").filter { $0.isNumber }
                return !unionPayRangeRegex.hasMatch(clean) || !isValidLuhnNumber(clean)
            }
            return ($0 ?? "").count < 16 || !isValidLuhnNumber($0 ?? "")
        }
        addRule(error: "unsupported-network".localized()) {
            getCardNetwork($0 ?? "", in: self.supportedNetworks) == .unknown
        }
    }
}

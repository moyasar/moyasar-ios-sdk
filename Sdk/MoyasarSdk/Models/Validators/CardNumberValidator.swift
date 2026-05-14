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
            // UnionPay: length check only (16–19 digits), no Luhn — UnionPay cards do not
            // universally follow Luhn, and decline test cards intentionally fail it.
            let network = getCardNetwork($0 ?? "", in: self.supportedNetworks)
            if network == .unionpay {
                let clean = ($0 ?? "").filter { $0.isNumber }
                return !(16...19).contains(clean.count)
            }
            // All other networks: original production rule — untouched
            return ($0 ?? "").count < 16 || !isValidLuhnNumber($0 ?? "")
        }
        addRule(error: "unsupported-network".localized()) {
            getCardNetwork($0 ?? "", in: self.supportedNetworks) == .unknown
        }
    }
}

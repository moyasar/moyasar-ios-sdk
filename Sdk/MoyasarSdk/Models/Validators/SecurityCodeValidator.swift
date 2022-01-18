//
//  SecurityCodeValidator.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 31/08/2021.
//

import Foundation

class SecurityCodeValidator: FieldValidator {
    init(getNumber: @escaping () -> String) {
        super.init()
        addRule(error: "cvc-required".localized()) {
            ($0 ?? "").isEmpty
        }
        addRule(error: "invalid-cvc".localized()) {
            ($0?.count ?? 0) != (getCardNetwork(getNumber()) == .amex ? 4 : 3)
        }
    }
}

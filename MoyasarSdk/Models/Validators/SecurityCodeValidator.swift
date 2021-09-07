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
        addRule(error: "Security code is required") {
            ($0 ?? "").isEmpty
        }
        addRule(error: "Invalid security code") {
            ($0?.count ?? 0) != (getCardNetwork(getNumber()) == .amex ? 4 : 3)
        }
    }
}

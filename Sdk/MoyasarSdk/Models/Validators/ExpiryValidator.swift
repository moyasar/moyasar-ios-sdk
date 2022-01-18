//
//  ExpiryValidator.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 31/08/2021.
//

import Foundation

class ExpiryValidator: FieldValidator {
    override init() {
        super.init()
        addRule(error: "expiry-is-required".localized()) {
            ($0 ?? "").isEmpty
        }
        addRule(error: "invalid-expiry".localized()) {
            !(ExpiryDate.fromPattern($0 ?? "")?.isValid() ?? false)
        }
        addRule(error: "expired-card".localized()) {
            !(ExpiryDate.fromPattern($0 ?? "")?.inexpired() ?? false)
        }
    }
}

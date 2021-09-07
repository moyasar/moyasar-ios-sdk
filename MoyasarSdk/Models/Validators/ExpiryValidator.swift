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
        addRule(error: "Expiry is required") {
            ($0 ?? "").isEmpty
        }
        addRule(error: "Invalid expiry") {
            !(ExpiryDate.fromPattern($0 ?? "")?.isValid() ?? false)
        }
        addRule(error: "Expired card") {
            !(ExpiryDate.fromPattern($0 ?? "")?.inexpired() ?? false)
        }
    }
}

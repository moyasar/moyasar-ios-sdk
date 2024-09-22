//
//  STCValidator.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 12/09/2024.
//

import Foundation

class STCValidator: FieldValidator {
    
    override init() {
        super.init()
        // Rule for empty phone number
        addRule(error: "phone-number-required".localized()) {
            ($0 ?? "").isEmpty
        }
        // Rule for invalid Saudi phone number format
        addRule(error: "invalid-phone-number".localized()) { [weak self] in
            guard let self else { return false }
            let phoneNumber = $0 ?? ""
            return !self.isValidSaudiPhoneNumber(phoneNumber)
        }
    }
    
    func isValidSaudiPhoneNumber(_ phoneNumber: String) -> Bool {
        let pattern = #"^05\d{1}\s?\d{3}\s?\d{4}$"#
        let regexTest = NSPredicate(format:"SELF MATCHES %@", pattern)
        return regexTest.evaluate(with: phoneNumber)
    }
    
    func isValidOtp(_ otp: String) -> Bool {
        return otp.count >= 4 && otp.count <= 10
    }
}

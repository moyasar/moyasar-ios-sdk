//
//  ExpiryDate.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 29/08/2021.
//

import Foundation

struct ExpiryDate {
    var month: Int
    var year: Int
    
    static var cal = Calendar(identifier: .gregorian)
    
    func isValid() -> Bool {
        return month >= 1 && month <= 12 && year > 1900
    }
    
    func expired() -> Bool {
        guard let expiry = dateInstance() else {
            return false
        }
        return expiry < Date()
    }
    
    func inexpired() -> Bool {
        return !expired()
    }
    
    private func dateInstance() -> Date? {
        if !isValid() {
            return nil
        }
        
        var components = DateComponents()
        components.month = month
        components.year = year
        
        return ExpiryDate.cal.date(from: components)
    }
}

extension ExpiryDate {
    static func fromPattern(_ pattern: String) -> ExpiryDate? {
        let clean = pattern
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "/", with: "")
        
        if clean.count == 4 {
            let millennium = (ExpiryDate.cal.dateComponents([.year], from: Date()).year! / 100) * 100
            let year = Int(clean.substringByInt(start: 2, length: 2)) ?? 0
            
            return ExpiryDate(
                month: Int(clean.substringByInt(start: 0, length: 2)) ?? 0,
                year: year + millennium)
        } else if clean.count == 6 {
            return ExpiryDate(
                month: Int(clean.substringByInt(start: 0, length: 2)) ?? 0,
                year: Int(clean.substringByInt(start: 2, length: 4)) ?? 0)
        } else {
            return nil
        }
    }
}

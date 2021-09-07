//
//  CreditCardFormatter.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 25/08/2021.
//

import Foundation
import SwiftUI

final class CreditCardFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        if let string = obj as? String {
            return formatCardNumber(number: string)
        }
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = cleanNumber(string) as AnyObject
        return true
    }
    
    private func formatCardNumber(number: String) -> String {
        if number.hasPrefix("34") {
            return formatAmexNumber(number)
        }
        
        return formatVisaNumber(number)
    }
    
    private func formatAmexNumber(_ number: String) -> String {
        // 4-6-5
        return insertSpacesAtPosition(number, positions: [4, 10], max: 16)
    }
    
    private func formatVisaNumber(_ number: String) -> String {
        // 4-4-4-4
        return insertSpacesAtPosition(number, positions: [4, 8, 12], max: 16)
    }
    
    private func insertSpacesAtPosition(_ number: String, positions: [Int], max: Int) -> String {
        var number = cleanNumber(number)

        if number.count > max {
            number = String(number.prefix(max))
        }
        
        for pos in positions.sorted().reversed() {
            if number.count > pos {
                number.insert(" ", at: number.index(number.startIndex, offsetBy: pos))
            }
        }
        
        return number
    }
    
    private func cleanNumber(_ number: String) -> String {
        return number.filter { $0.isNumber }
    }
}

//
//  CreditCardFormatter.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 25/08/2021.
//

import Foundation

final class CreditCardFormatter {
    
    /// Formats the credit card number based on the card type
    func formatCardNumber(_ number: String) -> String {
        let cleaned = cleanNumber(number)
        
        // Check if the card is AMEX based on the starting digits
        let isAMEX = cleaned.starts(with: "34") || cleaned.starts(with: "37")
        
        return isAMEX ? formatAMEXCardNumber(cleaned) : formatOtherCardNumber(cleaned)
    }
    
    /// Format for AMEX: xxxx xxxxxx xxxxx  -->  4-6-5
    ///
    private func formatAMEXCardNumber(_ number: String) -> String {
        var formattedNumber = ""
        let segments = [4, 6, 5]
        var startIndex = number.startIndex
        
        for segment in segments {
            let endIndex = number.index(startIndex, offsetBy: segment, limitedBy: number.endIndex) ?? number.endIndex
            let segmentString = String(number[startIndex..<endIndex])
            formattedNumber += segmentString
            if endIndex < number.endIndex {
                formattedNumber += " "
            }
            startIndex = endIndex
        }
        
        return formattedNumber
    }
    
    /// Format for other cards: xxxx xxxx xxxx xxxx --> 4-4-4-4
    /// For UnionPay: 16-19 digits formatted as 4-4-4-4-4 (if 19 digits) or 4-4-4-4 (if 16 digits)
    ///
    private func formatOtherCardNumber(_ number: String) -> String {
        let cleanNumber = number.filter { $0.isNumber }
        let isUnionPay = cleanNumber.starts(with: "62") || cleanNumber.starts(with: "60") || cleanNumber.starts(with: "81")
        
        if isUnionPay {
            let maxLength = min(cleanNumber.count, 19)
            let truncated = cleanNumber.prefix(maxLength)
            
            if truncated.count == 19 {
                // 19 digits: 4-4-4-4-4 format
                return stride(from: 0, to: truncated.count, by: 4).map {
                    let start = truncated.index(truncated.startIndex, offsetBy: $0)
                    let end = truncated.index(start, offsetBy: 4, limitedBy: truncated.endIndex) ?? truncated.endIndex
                    return String(truncated[start..<end])
                }.joined(separator: " ")
            } else {
                // 16 digits: 4-4-4-4 format
                return stride(from: 0, to: truncated.count, by: 4).map {
                    let start = truncated.index(truncated.startIndex, offsetBy: $0)
                    let end = truncated.index(start, offsetBy: 4, limitedBy: truncated.endIndex) ?? truncated.endIndex
                    return String(truncated[start..<end])
                }.joined(separator: " ")
            }
        } else {
            // Other cards: 4-4-4-4 format
            let maxLength = 16
            let truncated = cleanNumber.prefix(maxLength)
            
            return stride(from: 0, to: truncated.count, by: 4).map {
                let start = truncated.index(truncated.startIndex, offsetBy: $0)
                let end = truncated.index(start, offsetBy: 4, limitedBy: truncated.endIndex) ?? truncated.endIndex
                return String(truncated[start..<end])
            }.joined(separator: " ")
        }
    }
    
    /// Formats the expiry date (e.g., "1225" to "12/25")
    ///
    func formatExpiryDate(_ date: String) -> String {
        let cleaned = cleanNumber(date).prefix(6)
        if cleaned.count > 2 {
            let month = cleaned.prefix(2)
            let year = cleaned.suffix(from: cleaned.index(cleaned.startIndex, offsetBy: 2))
            return "\(month) / \(year)"
        }
        return String(cleaned)
    }
    
    /// Formats the CVC
    ///
    func formatCVC(_ cvc: String, forCardNumber cardNumber: String) -> String {
        let cleaned = cleanNumber(cvc)
        let isAMEX = cardNumber.starts(with: "34") || cardNumber.starts(with: "37")
        return String(cleaned.prefix(isAMEX ? 4 : 3))
    }
    
    private func cleanNumber(_ number: String) -> String {
        return ArabicNumberMapper.mapArabicNumbers(number).filter { $0.isNumber }
    }
}

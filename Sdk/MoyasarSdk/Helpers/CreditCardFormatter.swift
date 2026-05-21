//
//  CreditCardFormatter.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 25/08/2021.
//

import Foundation

final class CreditCardFormatter {
    private enum Limits {
        static let standardCardDigits = 16
        static let unionPayDigits = 19
        static let expiryDigits = 6
        static let defaultCvcDigits = 3
        static let amexCvcDigits = 4
    }

    private enum Segments {
        static let groupOfFour = 4
        static let amexPattern = [4, 6, 5]
    }
    
    /// Formats the credit card number based on the card type
    func formatCardNumber(_ number: String) -> String {
        let clean = cleanNumber(number)

        if isAmex(clean) {
            return formatByPattern(clean, pattern: Segments.amexPattern)
        }

        if unionPayRangeRegex.hasMatch(clean) {
            return formatInGroupsOfFour(clean.prefix(Limits.unionPayDigits))
        }

        return formatInGroupsOfFour(clean.prefix(Limits.standardCardDigits))
    }

    // MARK: - Shared

    /// Splits a string into space-separated groups of 4 characters.
    private func formatInGroupsOfFour(_ number: some StringProtocol) -> String {
        return stride(from: 0, to: number.count, by: Segments.groupOfFour).map {
            let start = number.index(number.startIndex, offsetBy: $0)
            let end = number.index(start, offsetBy: Segments.groupOfFour, limitedBy: number.endIndex) ?? number.endIndex
            return String(number[start..<end])
        }.joined(separator: " ")
    }

    /// Splits a string based on custom segment sizes.
    private func formatByPattern(_ number: String, pattern: [Int]) -> String {
        var groups = [String]()
        var startIndex = number.startIndex

        for segmentLength in pattern where startIndex < number.endIndex {
            let endIndex = number.index(startIndex, offsetBy: segmentLength, limitedBy: number.endIndex) ?? number.endIndex
            groups.append(String(number[startIndex..<endIndex]))
            startIndex = endIndex
        }

        return groups.joined(separator: " ")
    }

    private func isAmex(_ number: String) -> Bool {
        number.hasPrefix("34") || number.hasPrefix("37")
    }
    
    /// Formats the expiry date (e.g., "1225" to "12/25")
    ///
    func formatExpiryDate(_ date: String) -> String {
        let clean = cleanNumber(date).prefix(Limits.expiryDigits)
        if clean.count > 2 {
            let month = clean.prefix(2)
            let year = clean.suffix(from: clean.index(clean.startIndex, offsetBy: 2))
            return "\(month) / \(year)"
        }
        return String(clean)
    }
    
    /// Formats the CVC
    ///
    func formatCVC(_ cvc: String, forCardNumber cardNumber: String) -> String {
        let cleaned = cleanNumber(cvc)
        let maxDigits = isAmex(cardNumber) ? Limits.amexCvcDigits : Limits.defaultCvcDigits
        return String(cleaned.prefix(maxDigits))
    }
    
    private func cleanNumber(_ number: String) -> String {
        return ArabicNumberMapper.mapArabicNumbers(number).filter { $0.isNumber }
    }
}

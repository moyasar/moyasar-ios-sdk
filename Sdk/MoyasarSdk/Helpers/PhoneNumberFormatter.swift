//
//  PhoneNumberFormatter.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 15/09/2024.
//

import Foundation

public final class PhoneNumberFormatter {
    /// Format for phone number: xxx xxx xxxx --> 3-3-4
    ///
    public func formatPhoneNumber(_ number: String) -> String {
        let cleanNumber = number.cleanNumber
        var formattedNumber = ""
        let segments = [3, 3, 4]
        var startIndex = cleanNumber.startIndex
        
        for (index, segment) in segments.enumerated() {
            let endIndex = cleanNumber.index(startIndex, offsetBy: segment, limitedBy: cleanNumber.endIndex) ?? cleanNumber.endIndex
            let segmentString = String(cleanNumber[startIndex..<endIndex])
            formattedNumber += segmentString
            
            // Add a space if it's not the last segment
            if endIndex < cleanNumber.endIndex && index < segments.count - 1 {
                formattedNumber += " "
            }
            startIndex = endIndex
        }
        return formattedNumber
    }
    
    private func numberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal  // No currency symbol
        formatter.locale = Locale.current
        return formatter
    }
    
    public func getFormattedAmount(paymentRequest: PaymentRequest) -> String {
        let currencyUtil = CurrencyUtil()
        let majorAmount = currencyUtil.toMajor(paymentRequest.amount, currency: paymentRequest.currency)
        let amountString = numberFormatter().string(from: majorAmount as NSNumber)!
        return  " \(amountString)"
    }
}

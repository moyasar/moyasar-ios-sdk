//
//  PhoneNumberFormatter.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 15/09/2024.
//

import Foundation

final class PhoneNumberFormatter {

    /// Format for phone number: xxx xxx xxxx --> 3-3-4
    ///
    func formatPhoneNumber(_ number: String) -> String {
        let cleanNumber = number.cleanNumber
        var formattedNumber = ""
        let segments = [3, 3, 4]
        var startIndex = cleanNumber.startIndex
        
        for segment in segments {
            let endIndex = cleanNumber.index(startIndex, offsetBy: segment, limitedBy: cleanNumber.endIndex) ?? cleanNumber.endIndex
            let segmentString = String(cleanNumber[startIndex..<endIndex])
            formattedNumber += segmentString
            if endIndex < cleanNumber.endIndex {
                formattedNumber += " "
            }
            startIndex = endIndex
        }
        
        return formattedNumber
    }
    
    private func numberFormatter(currencyCode: String) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.currencyCode = currencyCode
        return formatter
    }
    
    func getFormattedAmount(paymentRequest: PaymentRequest) -> String {
        let currencyUtil = CurrencyUtil()
        let majorAmount = currencyUtil.toMajor(paymentRequest.amount, currency: paymentRequest.currency)
        let formatter = numberFormatter(currencyCode: paymentRequest.currency)
        let amount = formatter.string(from: majorAmount as NSNumber)!
        return "pay".localized() + " \(amount)"
    }
}

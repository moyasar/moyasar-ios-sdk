//
//  ApiPaymentStatus.swift
//  MoyasarSdk
//
//  Created by Abdulaziz Alrabiah on 08/12/2023.
//

import Foundation

public enum ApiPaymentStatus: String, Codable {
    case initiated
    case paid
    case failed
    case authorized
    case captured
    case refunded
    case voided
    case verified
}

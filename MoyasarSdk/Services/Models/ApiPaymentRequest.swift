//
//  PaymentRequest.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 26/08/2021.
//

import Foundation

struct ApiPaymentRequest: Codable {
    var amount: Int
    var currency: String
    var description: String
    var callbackUrl: String
    var source: ApiPaymentSource
    var metadata: [String: String]?
}
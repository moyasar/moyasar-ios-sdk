//
//  CreditCardSource.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 26/08/2021.
//

import Foundation

public struct ApiCreditCardSource: Codable {
    var type: String = "creditcard"
    var name: String
    var number: String
    var month: String
    var year: String
    var cvc: String
}

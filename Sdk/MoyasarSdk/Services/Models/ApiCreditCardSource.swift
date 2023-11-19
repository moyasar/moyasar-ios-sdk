//
//  CreditCardSource.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 26/08/2021.
//

import Foundation

public struct ApiCreditCardSource: Codable {
    public init(
        type: String = "creditcard",
        name: String,
        number: String,
        month: String? = nil,
        year: String? = nil,
        cvc: String? = nil,
        transactionUrl: String? = nil,
        message: String? = nil,
        token: String? = nil,
        manual: String? = nil,
        saveCard: String? = nil
    ) {
        self.type = type
        self.name = name
        self.number = number
        self.month = month
        self.year = year
        self.cvc = cvc
        self.transactionUrl = transactionUrl
        self.message = message
        self.token = token
        self.manual = manual
        self.saveCard = saveCard
    }
    
    var type: String = "creditcard"
    var name: String
    var number: String
    var month: String?
    var year: String?
    var cvc: String?
    var transactionUrl: String?
    var message: String?
    var token: String?
    var manual: String?
    var saveCard: String?
}

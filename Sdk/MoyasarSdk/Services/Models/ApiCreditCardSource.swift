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
        saveCard: Bool? = false,
        company: String? = nil,
        gatewayId: String? = nil,
        referenceNumber: String? = nil,
        responseCode: String? = nil,
        authorizationCode: String? = nil,
        issuerName: String? = nil,
        issuerCountry: String? = nil,
        issuerCardType: String? = nil,
        isserCardCategory: String? = nil
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
        self.company = company
        self.gatewayId = gatewayId
        self.referenceNumber = referenceNumber
        self.responseCode = responseCode
        self.authorizationCode = authorizationCode
        self.issuerName = issuerName
        self.issuerCountry = issuerCountry
        self.issuerCardType = issuerCardType
        self.isserCardCategory = isserCardCategory
    }

    public var type: String = "creditcard"
    public var name: String
    public var number: String
    public var month: String?
    public var year: String?
    public var cvc: String?
    public var transactionUrl: String?
    public var message: String?
    public var token: String?
    public var manual: String?
    public var saveCard: Bool?
    public var company: String?
    public var gatewayId: String?
    public var referenceNumber: String?
    public var responseCode: String?
    public var authorizationCode: String?
    public var issuerName: String?
    public var issuerCountry: String?
    public var issuerCardType: String?
    public var isserCardCategory: String?
}


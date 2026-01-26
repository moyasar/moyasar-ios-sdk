//
//  PaymentSplit.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 26/01/2026.
//

public struct PaymentSplit: Codable, Equatable {
    public init(
        recipientId: String,
        amount: Int,
        reference: String? = nil,
        description: String? = nil,
        feeSource: Bool? = nil
    ) {
        self.recipientId = recipientId
        self.amount = amount
        self.reference = reference
        self.description = description
        self.feeSource = feeSource
    }
    
    public var recipientId: String
    public var amount: Int
    public var reference: String?
    public var description: String?
    public var feeSource: Bool?
}

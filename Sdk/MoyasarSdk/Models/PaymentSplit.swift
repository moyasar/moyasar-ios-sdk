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
        recipientType: String? = nil,
        reference: String? = nil,
        description: String? = nil,
        feeSource: Bool = false,
        refundable: Bool = true
    ) {
        self.recipientId = recipientId
        self.amount = amount
        self.recipientType = recipientType
        self.reference = reference
        self.description = description
        self.feeSource = feeSource
        self.refundable = refundable
    }
    
    /// Recipient identifier on Moyasar
    public var recipientId: String
    /// Amount for this split in the smallest currency unit
    public var amount: Int
    /// The type of recipient: "Entity", "Platform", or "Beneficiary"
    public var recipientType: String?
    /// Optional reference string you provide to correlate the split
    public var reference: String?
    /// Optional description for the split
    public var description: String?
    /// Set true to mark the split as a platform fee/commission
    public var feeSource: Bool
    /// If true, this split portion is refundable; if false, it is not refundable
    public var refundable: Bool

    enum CodingKeys: String, CodingKey {
        case recipientId = "recipient_id"
        case recipientType = "recipient_type"
        case amount, reference, description, feeSource = "fee_source", refundable
    }
}

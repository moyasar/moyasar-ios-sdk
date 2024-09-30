//
//  ApiSTCPaySource.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 17/09/2024.
//

import Foundation

// MARK: - ApiSTCPaySource
public struct ApiSTCPaySource: Codable {
    public let type: String?
    public let mobile: String?
    public let referenceNumber: String?
    public let transactionUrl: String?
    public let message: String?
}

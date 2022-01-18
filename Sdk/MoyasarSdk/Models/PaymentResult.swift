//
//  PaymentResult.swift
//  MoyasarSdk
//
//  Created by Ali Alhoshaiyan on 07/09/2021.
//

import Foundation

public enum PaymentResult {
    case completed(ApiPayment)
    case failed(Error)
    case canceled
}

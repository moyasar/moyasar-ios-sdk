//
//  ResultCallback.swift
//  MoyasarSdk
//
//  Created by Ali Alhoshaiyan on 07/09/2021.
//

import Foundation

public typealias ResultCallback = (_: PaymentResult) -> ()

public typealias STCResultCallback = (_: Result<ApiPayment, MoyasarError>) -> ()

//
//  ApiServiceError.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 01/09/2021.
//

import Foundation

enum ApiServiceError: Error {
    case apiError(ApiError)
    case runtimeError(Error)
    case unexpectedError(String)
    case decodingError(String)
}

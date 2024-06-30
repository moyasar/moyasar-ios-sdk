//
//  CreditCardView+Properties.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 30/06/2024.
//

extension CreditCardView {
    
    /// Determines whether the pay button should be disabled based on the view model's status.
    ///
    /// - Returns: A Boolean value indicating whether the pay button should be disabled.
    internal func shouldDisable() -> Bool {
        switch viewModel.status {
        case .reset:
            return false
        default:
            return true
        }
    }

    /// A Boolean value indicating whether the authentication view should be shown.
    var showAuth: Bool {
        if case .paymentAuth = viewModel.status {
            return true
        }
        return false
    }
    
    /// The URL for payment authentication.
    ///
    /// - Returns: A URL for authentication if available; otherwise, nil.
    var authUrl: URL? {
        if case .paymentAuth(let url) = viewModel.status {
            return URL(string: url)
        }
        return nil
    }
}

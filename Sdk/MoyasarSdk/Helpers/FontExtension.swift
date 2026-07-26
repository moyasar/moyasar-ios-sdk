//
//  FontExtension.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 04/08/2025.
//

import SwiftUI
import UIKit

// MARK: - Bundled Font Registration

/// The font files shipped inside the SDK bundle.
///
/// `UIAppFonts` in `Info.plist` only registers these when the SDK is embedded as a dynamic
/// framework. Swift Package Manager and static-library integrations never read that key, so the
/// fonts are registered with Core Text on first use instead.
private enum MoyasarFont: String, CaseIterable {
    case regular = "ReadexPro-Regular"
    case medium = "ReadexPro-Medium"

    /// Registers every bundled font exactly once, the first time it is read.
    private static let registerOnce: Void = {
        allCases.forEach { $0.register() }
    }()

    /// Returns the bundled font, falling back to the system font when it is unavailable.
    func uiFont(size: CGFloat) -> UIFont {
        _ = MoyasarFont.registerOnce
        return UIFont(name: rawValue, size: size) ?? .systemFont(ofSize: size, weight: systemFallbackWeight)
    }

    private var systemFallbackWeight: UIFont.Weight {
        switch self {
        case .regular: return .regular
        case .medium: return .medium
        }
    }

    private func register() {
        // Already registered by `UIAppFonts`, or by the host app shipping the same font.
        guard UIFont(name: rawValue, size: UIFont.systemFontSize) == nil else { return }

        guard let url = Bundle.moyasar.url(forResource: rawValue, withExtension: "ttf"),
              let data = try? Data(contentsOf: url),
              let provider = CGDataProvider(data: data as CFData),
              let font = CGFont(provider) else {
            assertionFailure("Moyasar SDK: missing bundled font \(rawValue).ttf")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            let description = error?.takeUnretainedValue().localizedDescription ?? "unknown error"
            assertionFailure("Moyasar SDK: failed to register \(rawValue).ttf — \(description)")
        }
    }
}

// MARK: - SwiftUI Font Extension

extension Font {
    static let readexProRegular = Font(MoyasarFont.regular.uiFont(size: 16))  // weight: 400
    static let readexProMedium = Font(MoyasarFont.medium.uiFont(size: 16))    // weight: 500
    static let readexProCaption = Font(MoyasarFont.regular.uiFont(size: 12))
}

// MARK: - UIKit Font Extension

extension UIFont {
    static var readexProRegular: UIFont { MoyasarFont.regular.uiFont(size: 16) }
    static var readexProMedium: UIFont { MoyasarFont.medium.uiFont(size: 16) }
}

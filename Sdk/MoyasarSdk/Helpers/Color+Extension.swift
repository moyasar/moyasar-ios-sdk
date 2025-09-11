//
//  Color+Extension.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 18/09/2024.
//

import SwiftUI
import UIKit

fileprivate func rgbComponents(from hex: String) -> (r: CGFloat, g: CGFloat, b: CGFloat)? {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

    var rgb: UInt64 = 0
    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

    let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
    let b = CGFloat(rgb & 0x0000FF) / 255.0
    return (r, g, b)
}

extension Color {
    init?(hex: String) {
        guard let components = rgbComponents(from: hex) else { return nil }
        self.init(red: Double(components.r), green: Double(components.g), blue: Double(components.b))
    }
}

extension UIColor {
    convenience init?(hex: String) {
        guard let components = rgbComponents(from: hex) else { return nil }
        self.init(red: components.r, green: components.g, blue: components.b, alpha: 1.0)
    }
}


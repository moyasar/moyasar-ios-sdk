//
//  FontExtension.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 04/08/2025.
//

import SwiftUI
import UIKit

// MARK: - SwiftUI Font Extension
extension Font {
    static let readexProRegular = Font.custom("ReadexPro-Regular", size: 16)    // weight: 400
    static let readexProMedium = Font.custom("ReadexPro-Medium", size: 16)      // weight: 500
}

// MARK: - UIKit Font Extension
extension UIFont {
    static var readexProRegular: UIFont? {
        return loadMoyasarFont(name: "ReadexPro-Regular", size: 16)
    }
    
    static var readexProMedium: UIFont? {
        return loadMoyasarFont(name: "ReadexPro-Medium", size: 16)
    }
    
    private static func loadMoyasarFont(name: String, size: CGFloat) -> UIFont? {
        if let font = UIFont(name: name, size: size) {
            return font
        }
        guard let url = Bundle.moyasar.url(forResource: name, withExtension: "ttf"),
              let data = NSData(contentsOf: url),
              let provider = CGDataProvider(data: data),
              let font = CGFont(provider) else {
            return UIFont.systemFont(ofSize: size)
        }
        CTFontManagerRegisterGraphicsFont(font, nil)
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
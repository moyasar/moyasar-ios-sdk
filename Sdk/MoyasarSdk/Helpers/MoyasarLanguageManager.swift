//
//  MoyasarLanguageManager.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 01/10/2024.
//

import Foundation
import SwiftUI

public enum LanguageCode: String {
    case ar = "ar"
    case en = "en"
}

private var bundleKey: UInt8 = 0
public class MoyasarLanguageManager {
    
    public static let shared = MoyasarLanguageManager()
    
    private init() {}
    
    /// Default retrun system langauge if not setted
    ///
    private var selectedLanguage: String = Locale.current.languageCode ?? "en"
    
    // Set the language based on the app’s or request's preferences
    public func setLanguage(_ language: LanguageCode) {
        guard let languageBundlePath = Bundle.moyasar.path(forResource: language.rawValue, ofType: "lproj"),
              let languageBundle = Bundle(path: languageBundlePath) else {
            print("Language bundle not found for language code: \(language.rawValue)")
            return
        }
        Bundle.swizzleMoyasarLocalization()
        selectedLanguage = language.rawValue
        objc_setAssociatedObject(Bundle.moyasar, &bundleKey, languageBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public var currentLanguage: LayoutDirection {
        selectedLanguage == "ar" ? .rightToLeft : .leftToRight
    }
}

extension Bundle {
    static func swizzleMoyasarLocalization() {
        guard let originalMethod = class_getInstanceMethod(Bundle.self, #selector(Bundle.localizedString(forKey:value:table:))),
              let swizzledMethod = class_getInstanceMethod(Bundle.self, #selector(Bundle.customMoyasarLocalizedString(forKey:value:table:))) else {
            return
        }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    @objc func customMoyasarLocalizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle {
            return bundle.customMoyasarLocalizedString(forKey: key, value: value, table: tableName)
        } else {
            return self.customMoyasarLocalizedString(forKey: key, value: value, table: tableName)
        }
    }
}

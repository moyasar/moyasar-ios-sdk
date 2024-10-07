import Foundation
import SwiftUI

let currentBundle: Bundle = {
    if let bundleUrl = Bundle.main.url(forResource: "com.moyasar.MoyasarSdk", withExtension: "bundle") {
        return Bundle(url: bundleUrl)!
    } else {
        return Bundle.init(identifier: "com.moyasar.MoyasarSdk") ?? Bundle.main
    }
}()

extension String {
    func substringByInt(start: Int, length: Int) -> String {
        let startOffset = self.index(self.startIndex, offsetBy: start)
        let offset = self.index(startOffset, offsetBy: length)
        return String(self[startOffset..<offset])
    }

    func localized() -> String {
        Bundle.moyasar.localizedString(forKey: self, value: nil, table: nil)
    }

    var sdkImage: Image {
        Image(self, bundle: Bundle.moyasar)
    }
    
    var cleanNumber: String {
        return ArabicNumberMapper.mapArabicNumbers(self).filter { $0.isNumber }
    }
}

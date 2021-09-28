import Foundation
import SwiftUI

let bundleUrl = Bundle.main.url(forResource: "com.moyasar.MoyasarSdk", withExtension: "bundle")!
let currentBundle = Bundle(url: bundleUrl)!

extension String {
    func substringByInt(start: Int, length: Int) -> String {
        let startOffset = self.index(self.startIndex, offsetBy: start)
        let offset = self.index(startOffset, offsetBy: length)
        return String(self[startOffset..<offset])
    }

    func localized() -> String {
        currentBundle.localizedString(forKey: self, value: nil, table: nil)
    }

    var sdkImage: Image {
        Image(self, bundle: currentBundle)
    }
}

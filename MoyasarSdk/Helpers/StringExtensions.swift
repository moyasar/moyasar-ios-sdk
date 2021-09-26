import Foundation
import SwiftUI

let currentBundle = Bundle(identifier: "com.moyasar.MoyasarSdk")!

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

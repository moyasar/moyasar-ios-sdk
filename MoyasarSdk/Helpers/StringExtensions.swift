import Foundation

extension String {
    func substringByInt(start: Int, length: Int) -> String {
        let startOffset = self.index(self.startIndex, offsetBy: start)
        let offset = self.index(startOffset, offsetBy: length)
        return String(self[startOffset..<offset])
    }
}

import Foundation

class ExpiryFormatter {
    func format(_ input: String) -> String {
        var cleanInput = input.filter { $0.isNumber }
        
        if (cleanInput.count > 6) {
            cleanInput = String(cleanInput.prefix(6))
        }
        
        if (cleanInput.count > 2) {
            cleanInput.insert(contentsOf: " / ", at: cleanInput.index(cleanInput.startIndex, offsetBy: 2))
        }
        
        return cleanInput
    }
}

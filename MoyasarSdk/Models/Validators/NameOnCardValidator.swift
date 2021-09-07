import Foundation

class NameOnCardValidator: FieldValidator {
    var latinRegex = try! NSRegularExpression(pattern: #"^[a-zA-Z\-\s]+$"#, options: [])
    
    override init() {
        super.init()
        addRule(error: "Name is Required") {
            ($0 ?? "").isEmpty
        }
        addRule(error: "Both first and last names are required") {
            ($0 ?? "").split(separator: " ").count < 2
        }
        addRule(error: "Name may only contain english alphabet") {
            self.latinRegex.numberOfMatches(in: $0 ?? "", options: [], range: NSMakeRange(0, $0?.count ?? 0)) == 0
        }
    }
}

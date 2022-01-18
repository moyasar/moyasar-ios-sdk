import Foundation

class NameOnCardValidator: FieldValidator {
    var latinRegex = try! NSRegularExpression(pattern: #"^[a-zA-Z\-\s]+$"#, options: [])
    
    override init() {
        super.init()
        addRule(error: "name-is-required".localized()) {
            ($0 ?? "").isEmpty
        }
        addRule(error: "both-names-required".localized()) {
            ($0 ?? "").split(separator: " ").count < 2
        }
        addRule(error: "only-english-alpha".localized()) {
            self.latinRegex.numberOfMatches(in: $0 ?? "", options: [], range: NSMakeRange(0, $0?.count ?? 0)) == 0
        }
    }
}

import Foundation

class FieldValidator {
    var rules = [ValidationRule]()
    private var shouldErr = false
    
    func addRule(error: String, predicate: @escaping Predicate) {
        rules.append(ValidationRule(predicate: predicate, error: error))
    }
    
    func visualValidate(value: String) -> String? {
        shouldErr = shouldErr || !value.isEmpty
        if !shouldErr {
            return nil
        }
        
        return validate(value: value)
    }
    
    func validate(value: String) -> String? {
        for rule in rules {
            if (rule.predicate(value)) {
                return rule.error
            }
        }
        return nil
    }
}

typealias Predicate = (_: String?) -> Bool

struct ValidationRule {
    var predicate: Predicate
    var error: String
}

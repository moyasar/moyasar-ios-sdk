//
//  TextEditGroup.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 29/08/2021.
//

import SwiftUI

struct TextEditGroup: View {
    var title: String
    @Binding var text: String
    var validator: FieldValidator
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text(validator.validate(value: text) ?? "")
                .font(.caption)
                .padding(.horizontal, 5)
        }
    }
}

struct TextEditGroup_Previews: PreviewProvider {
    @State static var name = ""
    static var validator: FieldValidator = {
        var validator = FieldValidator()
        validator.addRule(error: "Value is required", predicate: { ($0 ?? "").isEmpty })
        return validator
    }()
    
    static var previews: some View {
        TextEditGroup(title: "Name on Card", text: $name, validator: validator)
    }
}

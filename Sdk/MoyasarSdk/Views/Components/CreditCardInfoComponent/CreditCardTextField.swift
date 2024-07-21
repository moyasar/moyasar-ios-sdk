//
//  CreditCardTextField.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 11/07/2024.
//


import SwiftUI
import UIKit

import SwiftUI
import UIKit

struct CreditCardTextField: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CreditCardTextField

        init(parent: CreditCardTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return true }

            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            let formattedText = parent.formatter(newString)
            textField.text = formattedText

            // Manually set the new value to the binding
            parent.text = formattedText

            return false
        }
    }

    @Binding var text: String
    var placeholder: String
    var formatter: (String) -> String

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.keyboardType = .numberPad
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

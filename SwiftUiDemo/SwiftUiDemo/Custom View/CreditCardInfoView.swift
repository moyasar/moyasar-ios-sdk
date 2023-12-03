//
//  CreditCardInfoView.swift
//  SwiftUiDemo
//
//  Created by Abdulaziz Alrabiah on 02/12/2023.
//

import SwiftUI

struct CreditCardInfoView: View {
    
    var nameOnCard: String
    var number: String
    var expiryDate: String
    var securityCode: String
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Name on Card", text: .constant(nameOnCard))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(10)
                .disabled(true)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0), lineWidth: 0.4)
                )
            
            TextField("Card Number", text: .constant(number))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.numberPad)
                .padding(10)
                .disabled(true)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0), lineWidth: 0.4)
                )
            
            TextField("Expiry", text: .constant(expiryDate))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.numberPad)
                .padding(10)
                .disabled(true)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0), lineWidth: 0.4)
                )
            
            TextField("CVC", text: .constant(securityCode))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.numberPad)
                .padding(10)
                .disabled(true)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0), lineWidth: 0.4)
                )
        }
    }
}

#Preview {
    CreditCardInfoView(nameOnCard: "John Doe", number: "4111111111111111", expiryDate: "09/25", securityCode: "456")
}

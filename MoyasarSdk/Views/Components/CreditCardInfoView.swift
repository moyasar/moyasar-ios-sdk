//
//  CreditCardView.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 25/08/2021.
//

import SwiftUI

struct CreditCardInfoView: View {
    @ObservedObject var cardInfo: CreditCardViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Name on Card", text: $cardInfo.nameOnCard)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0), lineWidth: 0.4)
                )
            
            Text(cardInfo.nameValidator.visualValidate(value: cardInfo.nameOnCard) ?? " ")
                .padding(.horizontal, 5)
                .foregroundColor(.red)
                .font(.caption)
            
            TextField("Card Number", text: $cardInfo.number)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.numberPad)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0), lineWidth: 0.4)
                )
            
            Text(cardInfo.numberValidator.visualValidate(value: cardInfo.number) ?? " ")
                .padding(.horizontal, 5)
                .foregroundColor(.red)
                .font(.caption)
            
             TextField("Expiry", text: $cardInfo.expiryDate)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.numberPad)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0), lineWidth: 0.4)
                )
            
            Text(cardInfo.expiryValidator.visualValidate(value: cardInfo.expiryDate) ?? " ")
                .padding(.horizontal, 5)
                .foregroundColor(.red)
                .font(.caption)
            
            TextField("CVC", text: $cardInfo.securityCode)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.numberPad)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0), lineWidth: 0.4)
                )
            
            Text(cardInfo.securityCodeValidator.visualValidate(value: cardInfo.securityCode) ?? " ")
                .padding(.horizontal, 5)
                .foregroundColor(.red)
                .font(.caption)
        }
    }
}

struct CreditCardInfoView_Previews: PreviewProvider {
    static var paymentRequest = PaymentRequest(
        amount: 100,
        currency: "SAR",
        description: "Testing iOS SDK",
        apiKey: "pk_live_TH6rVePGHRwuJaAtoJ1LsRfeKYovZgC1uddh7NdX"
    )
    
    static var info = CreditCardViewModel(paymentRequest: paymentRequest)
    
    static var previews: some View {
        CreditCardInfoView(cardInfo: info)
    }
}

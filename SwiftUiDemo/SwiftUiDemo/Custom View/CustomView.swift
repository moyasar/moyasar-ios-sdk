//
//  CustomView.swift
//  SwiftUiDemo
//
//  Created by Abdulaziz Alrabiah on 27/11/2023.
//

import SwiftUI

// Below is a basic demo of how to use Moyasar's APIs with your own UI implementation (You shouldn't implement your UI and logic exactly like below)

fileprivate let applePayHandler = ApplePayPaymentHandler(paymentRequest: paymentRequest)

struct CustomView: View {
    
    @ObservedObject var viewModel = CustomViewModel()
    let buttonColor = Color(red: 0.137, green: 0.359, blue: 0.882)
    
    @ViewBuilder
    public var body: some View {
        if case .paymentAuth(let url) = viewModel.paymentStatus {
            PaymentAuthView(url: url) {result in viewModel.handleWebViewResult(result)}
        } else {
            if case .reset = viewModel.appStatus {
                ZStack {
                    VStack {
                        Text("Custom view basic demo")
                        
                        CreditCardInfoView(nameOnCard: viewModel.source.name, number: viewModel.source.number, expiryDate: "\(viewModel.source.month ?? "")/\(viewModel.source.year ?? "")", securityCode: viewModel.source.cvc ?? "")
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.beginPayment()
                        }, label: {
                            HStack {
                                Text("Pay 1.00 SAR")
                            }
                        })
                        .frame(maxWidth: .infinity, minHeight: 25)
                        .padding(14)
                        .foregroundColor(.white)
                        .font(.headline)
                        .background(buttonColor)
                        .cornerRadius(10)
                        
                        ApplePayButton(action: UIAction(handler: applePayPressed))
                            .frame(height: 50)
                            .cornerRadius(10)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    }
                    .padding()
                }
            } else if case let .success(payment) = viewModel.appStatus {
                VStack {
                    Text("Thank you for the payment")
                        .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    Text("Your payment ID is " + payment.id)
                        .font(.caption)
                }
            } else if case let .successToken(token) = viewModel.appStatus {
                VStack {
                    Text("Thank you for the token")
                        .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    Text("Your token ID is " + token.id)
                        .font(.caption)
                }
            } else if case let .failed(error) = viewModel.appStatus {
                Text("Whops 🤭")
                    .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Text("Something went wrong: " + error.localizedDescription)
                    .font(.caption)
            } else if case let .unknown(string) = viewModel.appStatus {
                Text("Hmmmmm 🤔")
                    .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Text("Something went wrong: " + string)
                    .font(.caption)
            }
        }
    }
    
    func applePayPressed(action: UIAction) {
        applePayHandler.present()
    }
}

#Preview {
    CustomView()
        .environment(\.locale, .init(identifier: "ar"))
        .preferredColorScheme(.dark)
}

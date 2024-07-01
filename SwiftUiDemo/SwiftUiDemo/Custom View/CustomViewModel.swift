//
//  CustomViewModel.swift
//  SwiftUiDemo
//
//  Created by Abdulaziz Alrabiah on 02/12/2023.
//

import MoyasarSdk


class CustomViewModel: ObservableObject {
    
    @Published var appStatus = MyAppStatus.reset
    @Published var paymentStatus = CreditCardPaymentStatus.reset
    
    var currentPayment: ApiPayment?
    let paymentService: PaymentService
    
    var source = ApiCreditCardSource(
        name: "John Doe",
        number: "4111111111111111",
        month: "09",
        year: "25",
        cvc: "456",
        manual: "false",
        saveCard: "false"
    )
    
    init() {
        do {
            self.paymentService = try  PaymentService(apiKey: "pk_test_vcFUHJDBwiyRu4Bd3hFuPpTnRPY4gp2ssYdNJMY3")
        } catch {
            print("Failed to initialize PaymentService: \(error)")
            fatalError()
        }
    }
    
    func beginPayment() {
        // Make sure to validate user input before initializing the payment process
        paymentStatus = .processing
        
        let paymentRequest = ApiPaymentRequest(
            amount: 100,
            currency: "SAR",
            description: "Flat White",
            callbackUrl: "https://sdk.moyasar.com/return",
            source: ApiPaymentSource.creditCard(source),
            metadata: ["sdk": "ios", "order_id": "ios_order_3214124"]
        )
        
        Task {
            do {
                let payment = try await paymentService.createPayment(paymentRequest)
                DispatchQueue.main.async {
                    self.currentPayment = payment
                    self.startPaymentAuthProcess(payment)
                }
            } catch {
                print("Payment creation error: \(error)")
            }
        }
    }
    
    func startPaymentAuthProcess(_ payment: ApiPayment) {
        guard payment.isInitiated() else {
            // Handle case
            // Payment status could be paid, failed, authorized, etc...
            return
        }
        
        guard case let .creditCard(source) = payment.source else {
            // Handle error
            return
        }
        
        guard let transactionUrl = source.transactionUrl, let url = URL(string: transactionUrl) else {
            // Handle error
            return
        }
        
        // Begin 3DS web view flow
        paymentStatus = .paymentAuth(url)
    }
    
    func handleWebViewResult(_ result: WebViewResult) {
        paymentStatus = .reset
        
        switch result {
        case .completed(let info):
            guard currentPayment != nil else {
                // Handle null payment!
                return
            }
            
            updatePaymentFromWebViewPaymentInfo(info, &currentPayment!)
            
            if (currentPayment!.status == .paid) {
                appStatus = .success(currentPayment!)
            } else {
                if case let .creditCard(source) = currentPayment!.source, currentPayment!.status == .failed {
                    appStatus = .failed(PaymentErrorSample.webViewAuthFailed(source.message ?? ""))
                    print("Payment failed: \(source.message ?? "")")
                } else {
                    // Handle payment statuses
                    appStatus = .success(currentPayment!)
                    print("Payment: \(currentPayment!)")
                }
            }
            break
        case .failed(let error):
            // Handle error
            appStatus = .failed(error)
            break
        }
    }
    
    func updatePaymentFromWebViewPaymentInfo(_ info: WebViewPaymentInfo, _ currentPayment: inout ApiPayment) {
        currentPayment.status = ApiPaymentStatus(rawValue: info.status)!
        
        if case var .creditCard(source) = currentPayment.source {
            source.message = info.message
            currentPayment.source = .creditCard(source)
        }
    }
}

enum CreditCardPaymentStatus {
    case reset
    case processing
    case paymentAuth(URL)
}

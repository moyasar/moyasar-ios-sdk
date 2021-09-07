//
//  PaymentAuthGroup.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 01/09/2021.
//

import SwiftUI
import WebKit

struct PaymentAuthView: View {
    var body: some View {
        Text("awd")
    }
}

struct PaymentAuthView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentAuthView()
    }
}

struct PaymentAuthInfo {
    var id: String
    var status: String
    var message: String?
}

enum PaymentAuthResult {
    case success(PaymentAuthInfo)
    case canceled
}

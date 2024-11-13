//
//  MoyasarColors.swift
//  MoyasarSdk
//
//  Created by Mahmoud Abdelwahab on 18/09/2024.
//

import SwiftUI

enum MoyasarColors {
    
    static var stcButtonColor: Color {
        UITraitCollection.current.userInterfaceStyle == .dark ? Color(hex: "#4F008C")! : Color(hex: "#4F008C")!
    }
    
    static var primaryTextColor: Color {
        UITraitCollection.current.userInterfaceStyle == .dark ? Color(hex: "#FFFFFF")! : Color(hex: "#1D1D1D")!
    }
    
    static var placeholderColor: Color {
        UITraitCollection.current.userInterfaceStyle == .dark ? Color(hex: "#9E9E9E")! : Color(hex: "#9E9E9E")!
    }
    
    static var borderColor: Color {
        UITraitCollection.current.userInterfaceStyle == .dark ? Color(hex: "#E0E0E0")! : Color(hex: "#E0E0E0")!
    }
    
    static var errorColor: Color {
        UITraitCollection.current.userInterfaceStyle == .dark ? Color(hex: "#F62323")! : Color(hex: "#F62323")!
    }
}

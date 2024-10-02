//
//  AppDelegate.swift
//  UIKitDemo
//
//  Created by Ali Alhoshaiyan on 06/10/2021.
//

import UIKit
import MoyasarSdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MoyasarLanguageManager.shared.setLanguage(.ar)
        return true
    }
}


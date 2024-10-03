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
        /// If you want the sdk language to be  same as the system language `you don't need to use this manager at all`
        /// If you want to set custom langauge for sdk please use the below line when you lunch the app we support Arabic and English ,
       /// MoyasarLanguageManager.shared.setLanguage(.ar)
        return true
    }
}

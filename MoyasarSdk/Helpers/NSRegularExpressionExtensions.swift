//
//  NSRegularExpressionExtensions.swift
//  MoyasarSdkApp
//
//  Created by Ali Alhoshaiyan on 28/08/2021.
//

import Foundation

extension NSRegularExpression {
    func hasMatch(_ target: String) -> Bool {
        return numberOfMatches(in: target, options: [], range: NSMakeRange(0, target.count)) > 0
    }
}

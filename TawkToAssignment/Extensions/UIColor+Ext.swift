//
//  UIColor+Ext.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation
import UIKit

extension UIColor {
    
    public convenience init(hexString: String) {
        var hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (hexString.hasPrefix("#")) {
            hexString = String(hexString.dropFirst())
        }
        let scanner = Scanner(string: hexString)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    
}

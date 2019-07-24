//
//  UIColor+Utilities.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Create UIColor from a hex value.
    /// https://stackoverflow.com/a/48072722/1588616
    public convenience init?(hex: String) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        var hex = hex
        
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        
        var hexValue: UInt64 = 0
        
        guard Scanner(string: hex).scanHexInt64(&hexValue) else {
            return nil
        }
        
        switch hex.count {
        case 3:
            red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
            green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
            blue = CGFloat(hexValue & 0x00F) / 15.0
        case 4:
            red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
            green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
            blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
            alpha = CGFloat(hexValue & 0x000F) / 15.0
        case 6:
            red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(hexValue & 0x0000FF) / 255.0
        case 8:
            red = CGFloat((hexValue & 0xFF00_0000) >> 24) / 255.0
            green = CGFloat((hexValue & 0x00FF_0000) >> 16) / 255.0
            blue = CGFloat((hexValue & 0x0000_FF00) >> 8) / 255.0
            alpha = CGFloat(hexValue & 0x0000_00FF) / 255.0
        default:
            return nil
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

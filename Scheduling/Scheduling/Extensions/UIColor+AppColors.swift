//
//  UIColor+AppColors.swift
//  Scheduling
//
//  Created by Glace on 2025-04-05.
//

import UIKit

extension UIColor {
    // Helper method to create UIColor from hex string
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // Primary and background colours
    static let appPrimary = UIColor(hex: "#00274D")
    static let appBackground = UIColor.white
    
    // Task status colours
    static let taskNotStarted = UIColor(hex: "#DC143C")
    static let taskInProgress = UIColor(hex: "#DAA520")
    static let taskCompleted = UIColor(hex: "#2E8B57")
}

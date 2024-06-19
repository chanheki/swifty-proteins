//
//  UIColor+Extension.swift
//  SharedExtensions
//
//  Created by Chan on 4/3/24.
//

import UIKit

public extension UIColor {
    
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    static func color(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return dark
            default:
                return light
            }
        }
    }
    
    static let proteins = UIColor(hex: 0xFF7F29)
    static let proteins2 = UIColor(hex: 0xFF9548)
    static let proteins3 = UIColor(hex: 0xFFDC6E)
    static let tableViewBackgroundColor = color(light: .systemGroupedBackground, dark: .systemGray5)
    static let folderGray = color(light: .systemGray3, dark: .systemGray2)
    static let webIconColor = color(light: .black, dark: .systemGray)
    static let dimmedViewColor = UIColor.black.withAlphaComponent(0.75)
    static let dark = UIColor(hex: 0x242424)
    static let backgroundColor = color(light: .white, dark: UIColor(hex: 0x242424))
    static let foregroundColor = color(light: UIColor(hex: 0x242424), dark: .white)
    
}

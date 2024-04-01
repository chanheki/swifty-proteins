//
//  UIView+Extension.swift
//  SharedExtensions
//
//  Created by Chan on 4/1/24.
//

import UIKit

import SharedModel

extension UIView {
    
    func toUserInterfaceStyle(_ theme: Theme) -> UIUserInterfaceStyle {
        switch theme {
        case .light: return UIUserInterfaceStyle.light
        case .dark: return UIUserInterfaceStyle.dark
        case .system: return UIUserInterfaceStyle.unspecified
        }
    }
    
}

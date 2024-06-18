//
//  UITextField+Extension.swift
//  SharedExtensions
//
//  Created by Chan on 6/18/24.
//

import UIKit

public extension UITextField {
    func setPlaceholder(text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

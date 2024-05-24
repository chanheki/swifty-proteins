//
//  UIView+Extension.swift
//  SharedExtensions
//
//  Created by Chan on 4/1/24.
//

import UIKit

import SharedExtensionsInterface

public extension Then where Self: AnyObject {
    
    func then(block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
    
}

extension UIView: Then {}

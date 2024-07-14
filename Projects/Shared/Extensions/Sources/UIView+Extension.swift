//
//  UIView+Extension.swift
//  SharedExtensions
//
//  Created by Chan on 7/14/24.
//

import UIKit

public extension UIView {
    func captureScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

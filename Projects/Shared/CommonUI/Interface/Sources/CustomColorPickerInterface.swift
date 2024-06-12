//
//  CustomColorPickerInterface.swift
//  SharedCommonUIInterface
//
//  Created by Chan on 6/11/24.
//

import UIKit

public protocol CustomColorPickerViewControllerProtocol: AnyObject {
    var delegate: CustomColorPickerDelegate? { get set }
    var element: String? { get set }
}

public protocol CustomColorPickerDelegate: AnyObject {
    func customColorPicker(_ picker: CustomColorPickerViewControllerProtocol, didSelectColor color: UIColor, for element: String)
}

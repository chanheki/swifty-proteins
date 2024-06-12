//
//  ColorCellInterface.swift
//  SharedCommonUI
//
//  Created by Chan on 6/11/24.
//

import UIKit

public protocol ColorCellProtocol: UITableViewCell {
    var delegate: ColorCellDelegate? { get set }
    var element: String? { get set }
    func configure(with element: String, color: UIColor)
}

public protocol ColorCellDelegate: AnyObject {
    func colorCell(_ cell: ColorCellProtocol, didUpdateColor color: UIColor, for element: String)
}

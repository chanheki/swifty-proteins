//
//  BiometricTableViewCell.swift
//  FeatureSettings
//
//  Created by Chan on 6/9/24.
//

import UIKit

public final class BiometricTableViewCell: UITableViewCell {
    public let switchControl: UISwitch
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        switchControl = UISwitch(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryView = switchControl
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

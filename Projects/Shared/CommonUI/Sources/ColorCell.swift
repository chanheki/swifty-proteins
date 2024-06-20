//
//  ColorCell.swift
//  SharedCommonUI
//
//  Created by Chan on 6/11/24.
//

import UIKit
import SharedCommonUIInterface

public class ColorCell: UITableViewCell, ColorCellProtocol {
    public static let identifier = "ColorCell"
    
    public weak var delegate: ColorCellDelegate?
    public var element: String?
    
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    private let elementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private let changeColorButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Change Color", for: .normal)
//        button.tintColor = .foregroundColor
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupProperty()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperty() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        //        changeColorButton.addTarget(self, action: #selector(didUpdateColor), for: .touchUpInside)
    }
    
    private func setupView() {
        contentView.addSubview(colorView)
        contentView.addSubview(elementLabel)
        contentView.addSubview(countLabel)

//        contentView.addSubview(changeColorButton)
//
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 30),
            colorView.heightAnchor.constraint(equalToConstant: 30),
            
            elementLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            elementLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            countLabel.leadingAnchor.constraint(equalTo: elementLabel.trailingAnchor, constant: 10),
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//            changeColorButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            changeColorButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    public func configure(with element: String, color: UIColor, count: Int) {
        self.element = element
        elementLabel.text = element
        countLabel.text = "\(count)"
        colorView.backgroundColor = color
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    @objc func didUpdateColor(_ color: UIColor) {
        guard let element = element else { return }
        delegate?.colorCell(self, didUpdateColor: color, for: element)
    }
}

//
//  UserButtonView.swift
//  SharedCommonUI
//
//  Created by Chan on 6/9/24.
//

import UIKit

public final class UserButtonView: UIView {
    private let button: UIButton
    
    var buttonHeightConstraint: NSLayoutConstraint!
    var buttonWidthConstraint: NSLayoutConstraint!
    
    public var largeSize: CGFloat = 44 {
        didSet {
            updateButtonSize()
        }
    }
    public var smallSize: CGFloat = 28 {
        didSet {
            updateButtonSize()
        }
    }
    
    public override init(frame: CGRect) {
        self.button = UIButton(type: .custom)
        super.init(frame: frame)
        
        setupView()
    }
    
    public convenience init() {
        self.init(frame: .zero)
        
        self.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: self.largeSize, height: self.smallSize))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: self.largeSize, weight: .light, scale: .large)
        let userImage = UIImage(systemName: "person.crop.circle", withConfiguration: largeConfig)
        
        self.button.setImage(userImage, for: .normal)
        self.button.tintColor = .foregroundColor
        self.button.imageView?.contentMode = .scaleAspectFit
        
        addSubview(self.button)
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.buttonHeightConstraint = self.button.heightAnchor.constraint(equalToConstant: self.largeSize)
        self.buttonWidthConstraint = self.button.widthAnchor.constraint(equalToConstant: self.largeSize)
        
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.buttonHeightConstraint,
            self.buttonWidthConstraint
        ])
    }
    
    private func updateButtonSize() {
        self.buttonHeightConstraint.constant = isLarge ? largeSize : smallSize
        self.buttonWidthConstraint.constant = isLarge ? largeSize : smallSize
        self.invalidateIntrinsicContentSize()
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: buttonWidthConstraint.constant, height: buttonHeightConstraint.constant)
    }
    
    public var isLarge: Bool = true {
        didSet {
            updateButtonSize()
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button.addTarget(target, action: action, for: controlEvents)
    }
}

// NavigationBar.swift
// SharedCommonUI
//
// Created by Chan on 5/23/24.
//

import UIKit

import SharedExtensions

public final class NavigationBar: UIView {
    public var backButton = UIButton()
    public var titleLabel = UILabel()
    public var addButton = UIButton()
    public var moreButton = UIButton()
    public var doneButton = UIButton()
    public var userButton = UIButton()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        self.backButton.configuration = .plain()
        self.backButton.configuration?.image = UIImage(systemName: "chevron.left")
        self.backButton.configuration?.preferredSymbolConfigurationForImage = .init(weight: .semibold)
        self.addButton.configuration = .plain()
        self.addButton.configuration?.image = UIImage(systemName: "plus")
        self.addButton.configuration?.preferredSymbolConfigurationForImage = .init(weight: .semibold)
        self.moreButton.configuration = .plain()
        self.moreButton.configuration?.image = UIImage(systemName: "ellipsis.circle")
        self.moreButton.configuration?.preferredSymbolConfigurationForImage = .init(weight: .semibold)
        self.doneButton.configuration = .plain()
        self.doneButton.configuration?.baseForegroundColor = .label
        self.doneButton.configuration?.attributedTitle = AttributedString("완료", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.pretendard(ofSize: 16, weight: .semiBold)]))
        self.userButton.configuration = .plain()
        self.userButton.configuration?.image = UIImage(systemName: "person.crop.circle")
        self.userButton.configuration?.preferredSymbolConfigurationForImage = .init(weight: .semibold)
        
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(addButton)
        addSubview(moreButton)
        addSubview(doneButton)
        addSubview(userButton)
    }
    
    private func setupLayout() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        userButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // NavigationBar Layout
            heightAnchor.constraint(equalToConstant: 60),
            
            // backButton Layout
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            // titleLabel Layout
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // moreButton Layout
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 24),
            moreButton.heightAnchor.constraint(equalToConstant: 24),
            
            // moreButton Layout
            userButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            userButton.widthAnchor.constraint(equalToConstant: 24),
            userButton.heightAnchor.constraint(equalToConstant: 24),
            
            // addButton Layout
            addButton.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -20),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 24),
            addButton.heightAnchor.constraint(equalToConstant: 24),
            
            // doneButton Layout
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            doneButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

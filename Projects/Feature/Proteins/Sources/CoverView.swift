// CoverView.swift
// SwiftyProteins
//
// Created by Chan on 5/23/24.
//

import UIKit

import SharedExtensions

public final class CoverView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Swifty Proteins"
        label.textAlignment = .center
        label.font = UIFontMetrics(forTextStyle: .title1)
            .scaledFont(for: UIFont.systemFont(ofSize: 36, weight: .bold))
        label.textColor = .foregroundColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .backgroundColor
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

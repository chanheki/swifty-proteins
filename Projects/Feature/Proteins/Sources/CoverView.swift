// CoverView.swift
// SwiftyProteins
//
// Created by Chan on 5/23/24.
//

import UIKit

public final class CoverView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.backgroundColor = .white
    }
}

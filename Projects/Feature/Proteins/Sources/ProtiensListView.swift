//
//  ProtiensListView.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import UIKit

import Domain

public final class ProteinsListView: UIView {
    
    var proteinsTableView: ProteinsListTableView!
    var viewModel: LigandsViewModel
    
    override init(frame: CGRect) {
        viewModel = LigandsViewModel()
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        viewModel = LigandsViewModel()
        super.init(coder: coder)
        commonInit()
    }
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            setupView()
        }
    }
    
    private func commonInit() {
        proteinsTableView = ProteinsListTableView(frame: .zero, style: .grouped, viewModel: viewModel)
    }
    
    private func setupView() {
        addSubview(proteinsTableView)
        
        proteinsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            proteinsTableView.topAnchor.constraint(equalTo: self.topAnchor),
            proteinsTableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            proteinsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            proteinsTableView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}
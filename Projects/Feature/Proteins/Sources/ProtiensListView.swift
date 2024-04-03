//
//  ProtiensListView.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import UIKit

import Domain
import Shared

public class ProteinsListView: UIView {
    
    var proteinsTableView: ProteinsListTableView
    var viewModel: LigandsViewModel
    
    override init(frame: CGRect) {
        viewModel = LigandsViewModel()
        proteinsTableView = ProteinsListTableView(frame: .zero, style: .grouped, viewModel: viewModel)
        
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        viewModel = LigandsViewModel()
        proteinsTableView = ProteinsListTableView(frame: .zero, style: .grouped, viewModel: viewModel)
        
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
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

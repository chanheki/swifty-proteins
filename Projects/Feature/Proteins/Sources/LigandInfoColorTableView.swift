//
//  LigandInfoColorTableView.swift
//  FeatureProteins
//
//  Created by Chan on 6/12/24.
//

import UIKit

// TODO: protocol 지향. 구현체 refactoring 필요.
import DomainProteins
import SharedCommonUIInterface
import SharedCommonUI

public class LigandInfoColorTableView: UITableView {
    
    private var viewModel: LigandViewModel
    private var colorTableViewDelegate: ColorTableViewDelegate?
    
    public init(viewModel: LigandViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .plain)
        setupProperty()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperty() {
        self.delegate = self
        self.dataSource = self
        self.register(ColorCell.self, forCellReuseIdentifier: ColorCell.identifier)
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
    }
    
    public func setColorTableViewDelegate(_ delegate: ColorTableViewDelegate) {
        self.colorTableViewDelegate = delegate
    }
}

extension LigandInfoColorTableView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.elements.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColorCell.identifier, for: indexPath) as! ColorCell
        let element = viewModel.elements[indexPath.row]
        cell.configure(with: element, color: viewModel.color(for: element))
        cell.delegate = colorTableViewDelegate
        return cell
    }
}

public protocol ColorTableViewDelegate: ColorCellDelegate {}
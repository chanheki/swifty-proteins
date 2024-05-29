//
//  ProteinsListTableView.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import UIKit

import Domain
import Shared

// ProteinsListTableView가 TableView의 모든것을 담당 (ex. DataSource, Delegate)
public final class ProteinsListTableView: UITableView {
    
    private var viewModel: LigandsViewModel
    
    init(frame: CGRect, style: UITableView.Style, viewModel: LigandsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(coder: NSCoder, viewModel: LigandsViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
        commonInit()
    }
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            dataDelegateInit()
        }
    }
    
    private func commonInit() {
        register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        sectionHeaderTopPadding = 0
        backgroundColor = .white
        separatorStyle = .singleLine
        tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: CGFloat.leastNonzeroMagnitude))
    }
    
    private func dataDelegateInit() {
        dataSource = self
        delegate = self
    }
    
}

// UITableViewDataSource 구현
extension ProteinsListTableView: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionTitles.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = viewModel.sectionTitles[section]
        return viewModel.ligandsBySection[sectionKey]?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sectionKey = viewModel.sectionTitles[indexPath.section]
        if let ligand = viewModel.ligandsBySection[sectionKey]?[indexPath.row] {
            cell.textLabel?.text = ligand.identifier
        }
        return cell
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.sectionTitles
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel.sectionTitles.firstIndex(of: title) ?? 0
    }
}

// UITableViewDelegate 구현
extension ProteinsListTableView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitles[section]
    }

    // UITableViewDelegate 메서드 구현 (옵션)
    // 예: public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}

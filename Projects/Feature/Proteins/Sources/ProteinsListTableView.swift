//
//  ProteinsListTableView.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import UIKit

import FeatureProteinsInterface
import Domain
import SharedExtensions

// ProteinsListTableView가 TableView의 모든것을 담당 (ex. DataSource, Delegate)
public final class ProteinsListTableView: UITableView {
    
    private var viewModel: LigandsListViewModel
    weak var selectionDelegate: ProteinsListTableViewDelegate?
    
    init(frame: CGRect, style: UITableView.Style, viewModel: LigandsListViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(coder: NSCoder, viewModel: LigandsListViewModel) {
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
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.separatorStyle = .singleLine
        self.backgroundColor = .backgroundColor
        
        // 섹션 헤더
        self.sectionHeaderTopPadding = 0
        // 섹션 인덱스 스타일 설정
        self.sectionIndexColor = .foregroundColor
        self.sectionIndexBackgroundColor = .clear
        self.sectionIndexTrackingBackgroundColor = .lightGray.withAlphaComponent(0.6)
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionDelegate?.tableView(tableView, didSelectRowAt: indexPath)
    }
    
}

extension ProteinsListTableView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        selectionDelegate?.scrollViewDidScroll(scrollView)
    }
    
}

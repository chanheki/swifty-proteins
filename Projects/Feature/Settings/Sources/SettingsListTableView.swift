//
//  SettingsListTableView.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/4/24.
//

import UIKit

import DomainSettings
import SharedExtensions

protocol UserSettingListTableViewDelegate: AnyObject {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

// ProteinsListTableView가 TableView의 모든것을 담당 (ex. DataSource, Delegate)
public final class SettingsListTableView: UITableView {
    
    private var viewModel: SettingsViewModel
    weak var selectionDelegate: UserSettingListTableViewDelegate?

    init(frame: CGRect, style: UITableView.Style, viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(coder: NSCoder, viewModel: SettingsViewModel) {
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
        separatorStyle = .singleLine
        backgroundColor = .backgroundColor
      
        // 섹션 헤더
        sectionHeaderTopPadding = 0
        
        // 섹션 인덱스 스타일 설정
        sectionIndexColor = .foregroundColor
        sectionIndexBackgroundColor = .clear
        sectionIndexTrackingBackgroundColor = .lightGray.withAlphaComponent(0.6)
    }
    
    private func dataDelegateInit() {
//        dataSource = self
//        delegate = self
    }
    
}

// UITableViewDataSource 구현
//extension SettingsListTableView: UITableViewDataSource {
//    
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel.sectionTitles.count
//    }
//    
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let sectionKey = viewModel.sectionTitles[section]
//        return viewModel.ligandsBySection[sectionKey]?.count ?? 0
//    }
//    
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let sectionKey = viewModel.sectionTitles[indexPath.section]
//        if let ligand = viewModel.ligandsBySection[sectionKey]?[indexPath.row] {
//            cell.textLabel?.text = ligand.identifier
//        }
//        return cell
//    }
//    
//    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return viewModel.sectionTitles
//    }
//    
//    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        return viewModel.sectionTitles.firstIndex(of: title) ?? 0
//    }
//}
//
//// UITableViewDelegate 구현
//extension SettingsListTableView: UITableViewDelegate {
//    
//    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return viewModel.sectionTitles[section]
//    }
//    
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectionDelegate?.tableView(tableView, didSelectRowAt: indexPath)
//    }
//
//}

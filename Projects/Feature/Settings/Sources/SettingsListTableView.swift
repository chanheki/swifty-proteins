//
//  SettingsListTableView.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/4/24.
//

import UIKit

import FeatureSettingsInterface
import DomainSettings
import SharedExtensions

// SettingsListTableView가 TableView의 모든것을 담당 (ex. DataSource, Delegate)
public final class SettingsListTableView: UITableView {
    
    private var viewModel: SettingsViewModel
    weak var selectionDelegate: SettingsListTableViewDelegate?
    
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
        register(BiometricTableViewCell.self, forCellReuseIdentifier: "biometricCell")
        separatorStyle = .singleLine
        backgroundColor = .backgroundColor
        
        // 섹션 헤더
        sectionHeaderTopPadding = 0
    }
    
    private func dataDelegateInit() {
        dataSource = self
        delegate = self
    }
    
    
    @objc private func biometricSwitchChanged(_ sender: UISwitch) {
        viewModel.toggleBiometric(sender.isOn)
    }
}


extension SettingsListTableView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settings.count
    }
}

extension SettingsListTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = viewModel.settings[indexPath.row]
        
        switch setting {
        case .id:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "User ID"
            cell.textLabel?.textColor = .label
            cell.accessoryType = .none
            return cell
            
        case .resetPassword:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Reset Password"
            cell.textLabel?.textColor = .label
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case .biometric:
            let cell = tableView.dequeueReusableCell(withIdentifier: "biometricCell", for: indexPath) as! BiometricTableViewCell
            cell.textLabel?.text = "Biometric Authentication"
            cell.textLabel?.textColor = .label
            cell.switchControl.isOn = false
            cell.switchControl.addTarget(self, action: #selector(biometricSwitchChanged(_:)), for: .valueChanged)
            return cell
            
        case .logout:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Logout"
            cell.textLabel?.textColor = .red
            cell.accessoryType = .none
            return cell
            
        case .unsubscribe:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Unsubscribe"
            cell.textLabel?.textColor = .red
            cell.accessoryType = .none
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionDelegate?.tableView(tableView, didSelectRowAt: indexPath)
    }
}

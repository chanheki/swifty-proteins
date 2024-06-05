//
//  SettingsView.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/4/24.
//

import UIKit

import DomainSettings

public final class SettingsView: UIView {
    
    var UserSettingTableView: SettingsListTableView!
    var viewModel: SettingsViewModel
    
    override init(frame: CGRect) {
        viewModel = SettingsViewModel()
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        viewModel = SettingsViewModel()
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
        UserSettingTableView = SettingsListTableView(frame: .zero, style: .plain, viewModel: viewModel)
    }
    
    private func setupView() {
        addSubview(UserSettingTableView)
        
        UserSettingTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            UserSettingTableView.topAnchor.constraint(equalTo: self.topAnchor),
            UserSettingTableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            UserSettingTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            UserSettingTableView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}

//
//  SettingsView.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/4/24.
//

import UIKit

import DomainSettings

public final class SettingsView: UIView {
    
    var settingListTableView: SettingsListTableView!
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
        self.settingListTableView = SettingsListTableView(frame: .zero, style: .plain, viewModel: viewModel)
    }
    
    private func setupView() {
        addSubview(self.settingListTableView)
        
        self.settingListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.settingListTableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.settingListTableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.settingListTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.settingListTableView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}

//
//  SettingsViewController.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/4/24.
//

import UIKit
import Combine

import DomainSettings
import SharedCommonUI
import SharedModel

public class SettingsViewController: BaseViewController<SettingsView> {
    
    private let viewModel = SettingsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupProperty()
        setupView()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        
    }

    private func fetchData(liganName: String) {
        
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        self.setNavigationBarHidden(true)
    }
    
    public override func setupProperty() {
        view.backgroundColor = .backgroundColor
        self.activityIndicator.startAnimating()
    }
    
    private func setupView() {
        view.addSubview(activityIndicator)
        view.addSubview(dataLabel)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            dataLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20),
            dataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}


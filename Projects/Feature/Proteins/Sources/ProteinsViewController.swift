//
//  ProteinsViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import UIKit
import SceneKit
import Combine

import DomainProteins
import SharedCommonUI
import SharedModel

public class ProteinsViewController: BaseViewController<ProteinsView> {
    var ligand: Ligand?
    
    private let viewModel = LigandViewModel()
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
        fetchData(liganName: self.ligand?.identifier ?? "")
        
        let proteinsView = self.contentView as! ProteinsView
        // Setup your SCNView for Test
        proteinsView.sceneView.accessibilityIdentifier = "sceneView"
        print("Scene view accessibility identifier set")
    }
    
    private func bindViewModel() {
        self.viewModel.$ligandData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                if let data = data {
                    self.dataLabel.text = "Data loaded: \(data.count) bytes"
                }
            }
            .store(in: &cancellables)
        
        self.viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                if let errorMessage = errorMessage {
                    self.dataLabel.text = "Error: \(errorMessage)"
                }
            }
            .store(in: &cancellables)
        
        self.viewModel.$proteinScene
            .receive(on: DispatchQueue.main)
            .sink { [weak self] scene in
                guard let self = self, let scene = scene else { return }
                let proteinsView = self.contentView as! ProteinsView
                proteinsView.sceneView.scene = scene
                self.activityIndicator.stopAnimating()
                // testable identifier for Test
                proteinsView.sceneView.accessibilityIdentifier = "sceneView"
            }
            .store(in: &cancellables)
    }

    private func fetchData(liganName: String) {
        self.viewModel.fetchLigandData(for: liganName)
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


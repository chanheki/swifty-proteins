//
//  ProteinsViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import UIKit
import SceneKit
import Combine

import DomainProteinsInterface
import DomainProteins
import SharedCommonUI
import SharedModel

public class ProteinsViewController: BaseViewController<ProteinsView> {
    var ligand: LigandModel?
    
    private let viewModel = LigandViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["Ball-Stick", "Space-Filling"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupProperty()
        setupView()
        
        bindViewModel()
        fetchData(ligandName: self.ligand?.identifier ?? "")
        
        let proteinsView = self.contentView as! ProteinsView
        // Setup your SCNView for Test
        proteinsView.sceneView.accessibilityIdentifier = "sceneView"
        print("Scene view accessibility identifier set")
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }
    
    private func bindViewModel() {
        self.viewModel.ligand = self.ligand
        self.viewModel.$proteinScene
            .receive(on: DispatchQueue.main)
            .sink { [weak self] scene in
                guard let self = self, let scene = scene else { return }
                let proteinsView = self.contentView as! ProteinsView
                proteinsView.sceneView.scene = scene
                self.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }
    
    private func fetchData(ligandName: String) {
        self.viewModel.fetchLigandData(for: ligandName)
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        self.setNavigationBarHidden(true)
        self.navigationItem.titleView = segmentedControl
        setupNavigationRightButton()
    }
    
    public override func setupProperty() {
        view.backgroundColor = .backgroundColor
        self.activityIndicator.startAnimating()
    }
    
    private func setupView() {
        view.addSubview(segmentedControl)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationRightButton() {
        // TODO: need view separate refactoring
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .light, scale: .large)
        let userImage = UIImage(systemName: "info.bubble", withConfiguration: largeConfig)
        let infoButton = UIBarButtonItem(image: userImage, style: .plain, target: self, action: #selector(showInfo))
        self.navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc private func showInfo() {
        let ligandInfoViewController = LigandInfoViewController(viewModel: viewModel)
        
        ligandInfoViewController.modalPresentationStyle = .popover
        if let popoverPresentationController = ligandInfoViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem
            popoverPresentationController.permittedArrowDirections = .any
            popoverPresentationController.delegate = self
        }
        self.present(ligandInfoViewController, animated: true, completion: nil)
    }
    
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.viewModel.animateToBallStickModel()
        case 1:
            self.viewModel.animateToSpaceFillingModel()
        default:
            break
        }
    }
}

extension ProteinsViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

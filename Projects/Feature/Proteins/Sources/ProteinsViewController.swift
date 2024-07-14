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
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.titleView = segmentedControl
        setupNavigationRightButton()
    }
    
    public override func setupProperty() {
        view.backgroundColor = .backgroundColor
        self.activityIndicator.startAnimating()
        
        self.segmentedControl.addTarget(self, action: #selector(self.segmentedControlChanged), for: .valueChanged)
    }
    
    private func setupView() {
        view.addSubview(self.segmentedControl)
        view.addSubview(self.activityIndicator)
        
        NSLayoutConstraint.activate([
            self.segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavigationRightButton() {
        // TODO: need view separate refactoring
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .light, scale: .large)
        
        let userImage = UIImage(systemName: "info.bubble", withConfiguration: largeConfig)
        let infoButton = UIBarButtonItem(image: userImage, style: .plain, target: self, action: #selector(showInfo))
        
        let shareImage = UIImage(systemName: "square.and.arrow.up", withConfiguration: largeConfig)
        let shareButton = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(shareScene))
        
        self.navigationItem.rightBarButtonItems = [infoButton, shareButton]
    }
    
    @objc private func showInfo() {
        let ligandInfoViewController = LigandInfoViewController(viewModel: viewModel)
        
        ligandInfoViewController.modalPresentationStyle = .popover
        if let popoverPresentationController = ligandInfoViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems?.first
            popoverPresentationController.permittedArrowDirections = .any
            popoverPresentationController.delegate = self
            popoverPresentationController.backgroundColor = .clear
        }
        self.present(ligandInfoViewController, animated: true, completion: nil)
    }
    
    @objc private func shareScene() {
        guard let proteinsView = self.contentView as? ProteinsView else { return }
        let renderer = SCNRenderer(device: nil, options: nil)
        renderer.scene = proteinsView.sceneView.scene
        let size = proteinsView.sceneView.bounds.size
        let image = renderer.snapshot(atTime: 0, with: size, antialiasingMode: .multisampling4X)
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems?.last
        }
        self.present(activityViewController, animated: true, completion: nil)
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

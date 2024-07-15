//
//  ProteinsViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import UIKit
import SceneKit
import Combine

import SharedExtensions
import SharedCommonUI
import DomainProteinsInterface
import DomainProteins

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
    
    private let tooltipView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.isHidden = true
        return view
    }()
    
    private let tooltipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupProperty()
        setupView()
        
        bindViewModel()
        fetchData(ligandName: self.ligand?.identifier ?? "")
        
        setupGestureRecognizers()
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
        
        self.viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self = self, let errorMessage = errorMessage else { return }
                self.showErrorView(message: errorMessage)
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
        view.addSubview(self.tooltipView)
        self.tooltipView.addSubview(self.tooltipLabel)
        
        NSLayoutConstraint.activate([
            self.segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            self.tooltipView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.tooltipView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            self.tooltipView.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            
            self.tooltipLabel.topAnchor.constraint(equalTo: tooltipView.topAnchor, constant: 10),
            self.tooltipLabel.leadingAnchor.constraint(equalTo: tooltipView.leadingAnchor, constant: 10),
            self.tooltipLabel.trailingAnchor.constraint(equalTo: tooltipView.trailingAnchor, constant: -10),
            self.tooltipLabel.bottomAnchor.constraint(equalTo: tooltipView.bottomAnchor, constant: -10),
        ])
    }
    
    private func setupNavigationRightButton() {
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
        
        guard let screenshot = proteinsView.captureScreenshot() else { return }
        
        let title = "Ligand \(self.ligand?.identifier ?? "")"
        let subtitle = "Check out this 3D protein structure!"
        let textToShare = "\(title)\n\n\(subtitle)"
        
        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: [textToShare, screenshot], applicationActivities: nil)
            if let popoverPresentationController = activityViewController.popoverPresentationController {
                popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems?.last
            }
            self.present(activityViewController, animated: true, completion: nil)
        }
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
    
    private func showErrorView(message: String) {
        let errorView = CustomErrorView(errorMessage: message, parentViewController: self)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        if let proteinsView = self.contentView as? ProteinsView {
            proteinsView.sceneView.addGestureRecognizer(tapGesture)
        }
        
        let dismissTooltipGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTooltip))
        dismissTooltipGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissTooltipGesture)
    }
    
    @objc private func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        guard let proteinsView = self.contentView as? ProteinsView else { return }
        
        let location = gestureRecognize.location(in: proteinsView.sceneView)
        let hitResults = proteinsView.sceneView.hitTest(location, options: [SCNHitTestOption.searchMode: SCNHitTestSearchMode.all.rawValue])
        
        if let result = hitResults.first {
            if result.node.name == "stick" { return }
            let atomType = result.node.name ?? "Unknown"
            showTooltip(at: location, with: atomType)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tooltipView.isHidden = true
        }
    }
    
    @objc private func dismissTooltip(_ gestureRecognize: UIGestureRecognizer) {
        let location = gestureRecognize.location(in: view)
        if tooltipView.frame.contains(location) {
            return
        }
        tooltipView.isHidden = true
    }
    
    private func showTooltip(at position: CGPoint, with text: String) {
        print(position.x, position.y, text)
        tooltipLabel.text = "Atom Type: \(text)"
        tooltipView.isHidden = false
        
        tooltipView.center = position
        tooltipView.frame.origin.y -= tooltipView.frame.height / 2
        tooltipView.frame.origin.x -= tooltipView.frame.width / 2
    }
}

extension ProteinsViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

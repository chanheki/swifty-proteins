//
//  LigandInfoViewController.swift
//  FeatureProteins
//
//  Created by Chan on 6/10/24.
//

import UIKit
import Combine

import DomainProteins
import SharedCommonUI
import SharedCommonUIInterface

public class LigandInfoViewController: UIViewController {
    
    private var viewModel: LigandViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .backgroundColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorTableView: LigandInfoColorTableView = {
        let tableView = LigandInfoColorTableView(viewModel: viewModel)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let backgroundColorButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Change Background Color", for: .normal)
        button.tintColor = .foregroundColor
        button.setTitleColor(.foregroundColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public init(viewModel: LigandViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperty()
        setupView()
        bindViewModel()
        updateDataLabel()
    }
    
    private func setupProperty() {
        view.backgroundColor = .clear
    }
    
    private func setupView() {
        view.addSubview(dataLabel)
        view.addSubview(colorTableView)
        view.addSubview(backgroundColorButton)
        
        backgroundColorButton.addTarget(self, action: #selector(changeBackgroundColor), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            dataLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            colorTableView.topAnchor.constraint(equalTo: dataLabel.bottomAnchor, constant: 20),
            colorTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            colorTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            colorTableView.heightAnchor.constraint(equalToConstant: 300),
            
            backgroundColorButton.topAnchor.constraint(equalTo: colorTableView.bottomAnchor, constant: 20),
            backgroundColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func bindViewModel() {
        self.viewModel.$ligandData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                if let data = data {
                    self.dataLabel.text = "\(self.viewModel.ligand?.identifier ?? "Unidentified ID")"
                    self.dataLabel.textColor = .foregroundColor
                    self.colorTableView.reloadData()
                    self.colorTableView.backgroundColor = .clear
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateDataLabel() {
        dataLabel.text = viewModel.ligandInfo
    }
    
    @objc private func changeBackgroundColor() {
        let customColorPicker = CustomColorPickerViewController()
        customColorPicker.delegate = self
        customColorPicker.modalPresentationStyle = .custom
        customColorPicker.transitioningDelegate = self
        present(customColorPicker, animated: true, completion: nil)
    }
}

extension LigandInfoViewController: CustomColorPickerDelegate {
    public func customColorPicker(_ picker: CustomColorPickerViewControllerProtocol, didSelectColor color: UIColor, for element: String) {
        viewModel.updateBackgroundColor(color)
    }
}

extension LigandInfoViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

//
//  CustomColorPickerDelegate.swift
//  SharedCommonUI
//
//  Created by Chan on 6/11/24.
//

import UIKit

import SharedCommonUIInterface

public final class CustomColorPickerViewController: UIViewController, CustomColorPickerViewControllerProtocol {
    public weak var delegate: CustomColorPickerDelegate?
    public var element: String?
    
    private let colors: [UIColor] = [.red, .green, .blue, .yellow, .purple, .orange, .cyan, .magenta, .brown, .black, .white, .gray]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let alphaSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 1
        return slider
    }()
    
    private var selectedColor: UIColor = .backgroundColor
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperty()
        setupView()
    }
    
    private func setupProperty() {
        view.backgroundColor = UIColor.foregroundColor.withAlphaComponent(0.5)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        
        alphaSlider.addTarget(self, action: #selector(alphaSliderChanged), for: .valueChanged)
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        view.addSubview(alphaSlider)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 110),
            
            alphaSlider.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            alphaSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            alphaSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func alphaSliderChanged() {
        let newColor = selectedColor.withAlphaComponent(CGFloat(alphaSlider.value))
        delegate?.customColorPicker(self, didSelectColor: newColor, for: element ?? "")
    }
}

extension CustomColorPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        cell.layer.cornerRadius = 25
        cell.layer.masksToBounds = true
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colors[indexPath.row]
        let newColor = selectedColor.withAlphaComponent(CGFloat(alphaSlider.value))
        delegate?.customColorPicker(self, didSelectColor: newColor, for: element ?? "")
    }
}

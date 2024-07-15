//
//  ProteinsView.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import UIKit
import SceneKit

open class ProteinsView: UIView {
    let sceneView: SCNView = {
        let view = SCNView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoenablesDefaultLighting = true
        view.allowsCameraControl = true
        return view
    }()
    
    public let tooltipView: UIView = {
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
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(sceneView)
        addSubview(tooltipView)
        tooltipView.addSubview(tooltipLabel)
        
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tooltipView.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            
            tooltipLabel.topAnchor.constraint(equalTo: tooltipView.topAnchor, constant: 10),
            tooltipLabel.leadingAnchor.constraint(equalTo: tooltipView.leadingAnchor, constant: 10),
            tooltipLabel.trailingAnchor.constraint(equalTo: tooltipView.trailingAnchor, constant: -10),
            tooltipLabel.bottomAnchor.constraint(equalTo: tooltipView.bottomAnchor, constant: -10),
        ])
    }
    
    func showTooltip(at position: CGPoint, with text: String) {
        tooltipLabel.text = "Atom Type: \(text)"
        
        DispatchQueue.main.async {
            let tooltipWidth: CGFloat = 200
            let tooltipHeight: CGFloat = 50
            
            var adjustedX = position.x - tooltipWidth / 2
            var adjustedY = position.y - tooltipHeight - 10
            
            if adjustedX < 10 {
                adjustedX = 10
            } else if adjustedX + tooltipWidth > self.bounds.width - 10 {
                adjustedX = self.bounds.width - tooltipWidth - 10
            }
            
            if adjustedY < 10 {
                adjustedY = position.y + 10
            }
            
            self.tooltipView.frame.origin = CGPoint(x: adjustedX, y: adjustedY)
            self.tooltipView.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tooltipView.isHidden = true
        }
    }
}

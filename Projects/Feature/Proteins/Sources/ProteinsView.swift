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
        
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            sceneView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

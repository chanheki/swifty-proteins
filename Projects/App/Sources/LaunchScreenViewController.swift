//
//  LaunchScreenViewController.swift
//  SwiftyProteins
//
//  Created by Chan on 5/29/24.
//

import UIKit

import SharedExtensions
import SharedDesignSystem

final class LaunchScreenViewController: UIViewController {
    let customLaunchScreenView = HelixAnimationView
    weak var delegate: LaunchScreenViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(customLaunchScreenView)
        
        customLaunchScreenView.backgroundColor = .white
        customLaunchScreenView.frame = view.bounds
        customLaunchScreenView.center = view.center
        customLaunchScreenView.alpha = 1
        customLaunchScreenView.animationSpeed = 1.5
        
        customLaunchScreenView.play { [weak self] _ in
            UIView.animate(withDuration: 0.3, animations: {
                self?.customLaunchScreenView.alpha = 1
            }, completion: { _ in
                self?.delegate?.launchScreenDidFinish()
            })
        }
    }
}

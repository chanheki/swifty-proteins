//
//  BiometricAuthenticationFlow.swift
//  FeatureBiometric
//
//  Created by Chan on 4/1/24.
//

import UIKit

import DomainBiometric

public class BiometricAuthenticationFlow {
    
    private var window: UIWindow?

    public init(window: UIWindow?) {
        self.window = window
    }

    public func start() {
        let authService = AuthenticationService()
        authService.authenticate { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.showMainViewController()
                } else {
                    self?.showFailureViewController(error: error)
                }
            }
        }
    }
    
    private func showMainViewController() {
        let mainViewController = UIViewController()
        mainViewController.view.backgroundColor = .orange
        window?.rootViewController = mainViewController
    }
    
    private func showFailureViewController(error: Error?) {
        let failureViewController = UIViewController()
        failureViewController.view.backgroundColor = .red
        window?.rootViewController = failureViewController
    }
}

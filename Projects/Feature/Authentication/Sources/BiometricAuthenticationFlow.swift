//
//  SceneDelegate.swift
//  SwiftyProteins
//
//  Created by Chan on 3/28/24.
//

import UIKit

import Domain

public class BiometricAuthenticationFlow {
    private var window: UIWindow?
    
    public init(window: UIWindow?) {
        self.window = window
    }
    
    public func start(completion: @escaping (Bool, Error?) -> Void) {
        let authService = AuthenticationService()
        authService.authenticate { success, error in
            completion(success, error)
        }
    }
    
    public func showMainViewController() {
        window?.rootViewController?.view.backgroundColor = .green
    }
    
    public func showFailureViewController(error: Error?) {
        window?.rootViewController?.view.backgroundColor = .red
        
        if let error = error {
            print("Authentication failed with error: \(error.localizedDescription)")
        }
    }
}

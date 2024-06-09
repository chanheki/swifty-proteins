//
//  BiometricAuthenticationFlow.swift
//  SwiftyProteins
//
//  Created by Chan on 3/28/24.
//

import UIKit

import DomainBiometric
import CoreAuthentication

public final class BiometricAuthenticationFlow {
    private var window: UIWindow?
    
    public init(window: UIWindow?) {
        self.window = window
    }
    
    public func start(completion: @escaping (Bool, Error?) -> Void) {
        let authenticator = BiometricAuthenticator()
        let authService = BiometricAuthenticationService(authenticator: authenticator)
        authService.authenticate { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
}

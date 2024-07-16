//
//  AuthenticationFlow.swift
//  SwiftyProteins
//
//  Created by Chan on 3/28/24.
//

import UIKit

import DomainAuthentication
import DomainBiometric
import CoreAuthentication

public final class AuthenticationFlow {
    public init() {}
    
    public func start(completion: @escaping (Bool, Error?) -> Void) {
        let authenticator = BiometricAuthenticator()
        let authService = BiometricAuthenticationService(authenticator: authenticator)
        authService.authenticate { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    public func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        let authService = AuthenticationManager()
        
        if authService.isSettingUserPassword() {
            if authService.isBiometricEnabled {
                self.start { success, error in
                    if success {
                        completion(true, nil)
                    } else {
                        authService.isBiometricEnabled = false
                        completion(false, error)
                    }
                }
            } else {
                completion(false, nil)
            }
        } else {
            completion(false, nil)
        }
    }
}

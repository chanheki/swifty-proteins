//
//  AuthenticationManager.swift
//  FeatureBiometric
//
//  Created by Chan on 4/1/24.
//

import UIKit

import DomainAuthenticationInterface
import CoreCoreDataProvider
import CoreAuthentication

public final class AuthenticationManager: AuthenticationService {
    
    public init() {}
    
    public func isUserLoggedIn() -> Bool {
        return CoreDataProvider.shared.fetchUserID() != nil
    }
    
    public func isSettingUserPassword() -> Bool {
        return CoreDataProvider.shared.fetchUserPassword() != nil
    }
    
    public func clearCoreData() {
        CoreDataProvider.shared.clearCoreData()
    }
    
    public func appleSignIn(presentingViewController: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        AppleOAuthManager.shared.startSignInWithAppleFlow(presentingViewController: presentingViewController, completion: completion)
    }
    
    public var isBiometricEnabled: Bool {
        get {
            return AppStateManager.shared.isBiometricEnabled
        }
        set {
            AppStateManager.shared.isBiometricEnabled = newValue
        }
    }
}

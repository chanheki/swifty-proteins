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
    
    public func saveTokensToCoreData(_ email: String, _ accessToken: String, _ refreshToken: String) {
        _ = CoreDataProvider.shared.createUserEntity(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    public func isUserLoggedIn() -> Bool {
        if let userEntities = CoreDataProvider.shared.fetchUserEntity() {
            return true
        }
        return false
    }
    
    public func clearCoreData() {
        CoreDataProvider.shared.clearCoreData()
    }
    
    public func appleSignIn(presentingViewController: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        AppleOAuthManager.shared.startSignInWithAppleFlow(presentingViewController: presentingViewController, completion: completion)
    }
}

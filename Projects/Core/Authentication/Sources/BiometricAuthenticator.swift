//
//  BiometricAuthenticator.swift
//  FeatureBiometric
//
//  Created by Chan on 4/1/24.
//

import UIKit
import LocalAuthentication

import CoreAuthenticationInterface
import CoreCoreDataProvider

public final class BiometricAuthenticator: AuthenticationInterface {
    public init() {}

    public func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to access your account") { success, authenticationError in
                DispatchQueue.main.async {
                    if let laError = authenticationError as? LAError {
                        if laError.code == .biometryLockout {
                            AppStateManager.shared.isBiometricEnabled = false
                            completion(false, laError)
                        } else {
                            completion(success, authenticationError)
                        }
                    } else {
                        completion(success, authenticationError)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                AppStateManager.shared.isBiometricEnabled = false
                completion(false, error)
            }
        }
    }
}

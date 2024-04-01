//
//  BiometricAuthenticator.swift
//  FeatureBiometric
//
//  Created by Chan on 4/1/24.
//

import LocalAuthentication

public final class BiometricAuthenticator {
    public static func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to access") { success, authenticationError in
                completion(success, authenticationError)
            }
        } else {
            completion(false, error)
        }
    }
}

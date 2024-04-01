//
//  BiometricLogic.swift
//  FeatureBiometric
//
//  Created by Chan on 4/1/24.
//

import Foundation
import Core

public final class AuthenticationService {
    public init() {}

    public func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        BiometricAuthenticator.authenticate { success, error in
            completion(success, error)
        }
    }
}

//
//  BiometricLogic.swift
//  FeatureBiometric
//
//  Created by Chan on 4/1/24.
//

import Foundation
import Core

public final class AuthenticationService {
    private let authenticator: AuthenticationInterface
    
    public init(authenticator: AuthenticationInterface) {
        self.authenticator = authenticator
    }

    public func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        authenticator.authenticate { success, error in
            completion(success, error)
        }
    }
}

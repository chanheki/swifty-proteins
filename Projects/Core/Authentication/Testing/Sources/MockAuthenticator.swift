//
//  MockAuthenticator.swift
//  CoreAuthenticationTesting
//
//  Created by Chan on 5/23/24.
//

import CoreAuthenticationInterface

class MockAuthenticator: AuthenticationInterface {
    var shouldAuthenticateSuccessfully: Bool
    var error: Error?

    init(shouldAuthenticateSuccessfully: Bool, error: Error? = nil) {
        self.shouldAuthenticateSuccessfully = shouldAuthenticateSuccessfully
        self.error = error
    }

    func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        completion(shouldAuthenticateSuccessfully, error)
    }
}

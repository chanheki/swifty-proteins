//
//  AuthenticationServiceTests.swift
//  CoreAuthenticationTests
//
//  Created by Chan on 5/23/24.
//

import XCTest

@testable import DomainBiometric
@testable import CoreAuthenticationTesting

class AuthenticationServiceTests: XCTestCase {
    
    func testAuthenticationSuccess() {
        // Given
        let mockAuthenticator = MockAuthenticator(shouldAuthenticateSuccessfully: true)
        let authenticationService = BiometricAuthenticationService(authenticator: mockAuthenticator)
        
        // When
        let expectation = self.expectation(description: "Authentication should succeed")
        authenticationService.authenticate { success, error in
            // Then
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testAuthenticationFailure() {
        // Given
        let mockAuthenticator = MockAuthenticator(shouldAuthenticateSuccessfully: false, error: NSError(domain: "Test", code: 1, userInfo: nil))
        let authenticationService = BiometricAuthenticationService(authenticator: mockAuthenticator)
        
        // When
        let expectation = self.expectation(description: "Authentication should fail")
        authenticationService.authenticate { success, error in
            // Then
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

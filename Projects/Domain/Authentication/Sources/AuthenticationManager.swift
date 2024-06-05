//
//  AuthenticationManager.swift
//  FeatureBiometric
//
//  Created by Chan on 4/1/24.
//

import CoreCoreDataProvider

public final class AuthenticationManager {
    
    public static let shared = AuthenticationManager()
    private init() {}
    
    public func saveTokensToCoreData(_ email: String, _ accessToken: String, _ refreshToken: String) {
        _ = CoreDataProvider.shared.createUserEntity(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    public func isUserLoggedIn() -> Bool {
        if let userEntities = CoreDataProvider.shared.fetchUserEntity() {
            return true
        }
        return false
    }
}

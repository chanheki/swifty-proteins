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
        guard let userEntities = CoreDataProvider.shared.fetchUserEntity() else {
            return false
        }
        
        if let userEntity = userEntities.first,
           let email = userEntity.email,
           let accessToken = userEntity.accessToken,
           let refreshToken = userEntity.refreshToken {
            return !email.isEmpty && !accessToken.isEmpty && !refreshToken.isEmpty
        }
        
        return false
    }
    
    
}

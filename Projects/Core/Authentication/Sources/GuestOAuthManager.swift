//
//  GuestOAuthManager.swift
//  CoreAuthentication
//
//  Created by Chan on 9/30/26.
//

import FirebaseAuth

import CoreCoreDataProvider

/// Firebase 익명 로그인으로 Guest 사용자를 만든다.
/// Firebase 콘솔에서 Anonymous 제공자가 켜져 있어야 한다.
public final class GuestOAuthManager {
    public static let shared = GuestOAuthManager()
    private init() {}

    public func startGuestSignIn(completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                completion(false, error)
                return
            }

            guard let uid = authResult?.user.uid else {
                completion(false, NSError(domain: "GuestOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User information not found"]))
                return
            }

            if CoreDataProvider.shared.createUser(id: uid, name: "Guest") {
                AppStateManager.shared.userID = uid
                AppStateManager.shared.userName = "Guest"
                completion(true, nil)
            } else {
                completion(false, NSError(domain: "GuestOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Create User Error"]))
            }
        }
    }
}

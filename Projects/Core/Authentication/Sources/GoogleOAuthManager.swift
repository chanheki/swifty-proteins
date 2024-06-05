//
//  GoogleOAuthConfigure.swift
//  CoreAuthentication
//
//  Created by 민영재 on 6/1/24.
//

import Firebase
import GoogleSignIn
import AuthenticationServices

import CoreCoreDataProvider
import CoreData

public final class GoogleOAuthManager {
    public static let shared = GoogleOAuthManager()
    private init() {}

    public func firebaseConfig() {
        guard FirebaseApp.app() == nil else { return }
        let filePath = Bundle.module.path(forResource: "GoogleService-Info", ofType: "plist")!
        let options = FirebaseOptions(contentsOfFile: filePath)
        FirebaseApp.configure(options: options!)
    }

    public func googleOAuthConfig(url: URL) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    public func startGoogleSignIn(presenting viewController: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(false, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "ClientID not found"]))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in
            if let error = error {
                completion(false, error)
                return
            }

            guard let authentication = user?.authentication, let idToken = authentication.idToken else {
                completion(false, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing ID Token"]))
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(false, error)
                    return
                }

                guard let email = authResult?.user.email else {
                    completion(false, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email not found"]))
                    return
                }

                // CoreData에 저장
//                AuthenticationManager.shared.saveTokensToCoreData(email, authentication.accessToken, authentication.refreshToken)
                completion(true, nil)
            }
        }
    }
}

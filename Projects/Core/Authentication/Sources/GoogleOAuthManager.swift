//
//  GoogleOAuthConfigure.swift
//  CoreAuthentication
//
//  Created by 민영재 on 6/1/24.
//

import Firebase
import GoogleSignIn
import AuthenticationServices
import FirebaseFirestore

import CoreCoreDataProvider

public final class GoogleOAuthManager {
    public static let shared = GoogleOAuthManager()
    private init() {}
    
    public func firebaseConfig() {
        guard FirebaseApp.app() == nil else { return }
        guard let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            print("GoogleService-Info.plist not found")
            return
        }
        guard let options = FirebaseOptions(contentsOfFile: filePath) else {
            print("Invalid GoogleService-Info.plist")
            return
        }
        FirebaseApp.configure(options: options)
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
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { [weak self] user, error in
            guard self != nil else { return }
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
                
                guard let user = authResult?.user, let email = authResult?.user.email, let name = user.displayName else {
                    completion(false, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User information not found"]))
                    return
                }
                
                if CoreDataProvider.shared.createUser(id: email, name: name) {
                    AppStateManager.shared.userID = email
                    completion(true, nil)
                } else {
                    completion(false, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Create User Error"]))
                }
            }
        }
    }
    
    public func firebaseFetch(completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("Current user not found")
            completion(nil, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Current user not found"]))
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(currentUser.uid).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user info: \(error)")
                completion(nil, error)
                return
            }
            
            if let snapshot = snapshot, snapshot.exists {
                completion(snapshot.data(), nil)
            } else {
                print("User document not found")
                completion(nil, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found"]))
            }
        }
    }
    
    public func firebaseSignOut(completion: @escaping (Bool, Error?) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(true, nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(false, signOutError)
        }
    }
    
    public func firebaseDeleteAccount(completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("No signed-in user found")
            completion(false, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No signed-in user found"]))
            return
        }
        
        user.delete { error in
            if let error = error {
                print("Firebase Error: ", error)
                completion(false, error)
            } else {
                print("회원탈퇴 성공!")
                completion(true, nil)
            }
        }
    }
}

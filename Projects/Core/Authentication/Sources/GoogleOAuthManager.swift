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
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
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
                if (error as NSError).code ==
                    GIDSignInError.canceled.rawValue {
                    // 사용자가 로그인을 취소한 경우
                    completion(false, error)
                } else {
                    completion(false, error)
                }
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
                
                guard (authResult?.user.email) != nil else {
                    completion(false, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email not found"]))
                    return
                }
                
                guard let id = authResult?.user.providerID else {
                    completion(false, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"]))
                    return
                }
                
                guard let name = authResult?.user.displayName else {
                    completion(false, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Display Name not found"]))
                    return
                }
                
                if CoreDataProvider.shared.createUser(id: id, name: name) {
                    AppStateManager.shared.userID = id
                } else {
                    completion(false, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Create User Error"]))
                }
                
                completion(true, nil)
            }
        }
    }
    
    public func firebaseFetch() -> [String: Any]? {
        guard let currentUser = Auth.auth().currentUser else {
            print("Current user not found")
            return nil
        }
        
        let db = Firestore.firestore()
        var userInfo: [String: Any]?
        
        let semaphore = DispatchSemaphore(value: 0)
        db.collection("users").document(currentUser.uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching user info: \(error)")
                semaphore.signal()
                return
            }
            
            if let snapshot = snapshot, snapshot.exists {
                userInfo = snapshot.data()
            } else {
                print("User document not found")
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return userInfo
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
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("Firebase Error: ", error)
                    completion(false, error)
                } else {
                    print("회원탈퇴 성공!")
                    completion(true, nil)
                }
            }
        } else {
            print("로그인 정보가 존재하지 않습니다")
            completion(false, NSError(domain: "GoogleOAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No signed-in user found"]))
        }
    }
    
}

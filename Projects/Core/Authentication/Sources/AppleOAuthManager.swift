//
//  AppleOAuthManager.swift
//  CoreAuthentication
//
//  Created by Chan on 6/9/24.
//

import AuthenticationServices
import CryptoKit

import FirebaseAuth

import CoreCoreDataProvider

public final class AppleOAuthManager: NSObject {
    public static let shared = AppleOAuthManager()
    
    fileprivate var currentNonce: String?
    private var completion: ((Bool, Error?) -> Void)?
    
    private override init() {}
}

extension AppleOAuthManager {
    public func startSignInWithAppleFlow(presentingViewController: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        self.completion = completion
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension AppleOAuthManager: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce,
                  let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                self.completion?(false, NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from Apple ID service"]))
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                guard let self = self else { return }
                if let error = error {
                    self.completion?(false, error)
                    return
                }
                
                guard (authResult?.user) != nil else {
                    self.completion?(false, NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase authentication failed"]))
                    return
                }
                
                // 처음 로그인한 경우.
                if let fullName = appleIDCredential.fullName {
                    let displayName = [fullName.givenName, fullName.familyName].compactMap { $0 }.joined(separator: " ")
                    let email = appleIDCredential.email ?? ""
                    AppStateManager.shared.userName = displayName
                    
                    if !CoreDataProvider.shared.createUser(id: appleIDCredential.user, name: displayName) {
                        self.completion?(false, error)
                    }
                }
                
                AppStateManager.shared.userID = appleIDCredential.user
                self.completion?(true, nil)
            }
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 인증 실패 시
        completion?(false, error)
    }
}

extension AppleOAuthManager: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}

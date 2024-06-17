//
//  SceneDelegate.swift
//  SwiftyProteins
//
//  Created by Chan on 3/28/24.
//

import UIKit

import Feature
import DomainAuthentication
import CoreCoreDataProvider

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coverViewManager: CoverViewManager?
    var authenticationFlow: AuthenticationFlow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let launchScreenViewController = LaunchScreenViewController()
        launchScreenViewController.delegate = self
        window?.rootViewController = launchScreenViewController
        window?.makeKeyAndVisible()
        
        coverViewManager = CoverViewManager(window: window)
        authenticationFlow = AuthenticationFlow()
    }
    
    func showMainView() {
        // protein list view
        let initialViewController = ProteinsListViewController()
        
        window?.rootViewController = initialViewController.initialView()
        window?.makeKeyAndVisible()
    }
    
    func showLoginView() {
        let authService = AuthenticationManager()
        
        let loginViewController = LoginViewController(authService: authService)
        loginViewController.delegate = self
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
    }
    
    func showPasswordRegistrationView() {
        let passwordRegistrationViewController = PasswordRegistrationViewController()
        passwordRegistrationViewController.delegate = self
        window?.rootViewController = passwordRegistrationViewController
        window?.makeKeyAndVisible()
    }
    
    func showLoginSuccessView() {
        let loginSuccessViewController = PasswordRegistrationSuccessViewController()
        loginSuccessViewController.delegate = self
        window?.rootViewController = loginSuccessViewController
        window?.makeKeyAndVisible()
    }
    
    private func authenticateUser() {
        authenticationFlow?.authenticateUser { [weak self] success, error in
            if success {
                self?.coverViewManager?.removeCoverView()
                self?.passwordVerificationDidFinish(success: true)
            } else {
                self?.promptForPassword()
            }
        }
    }
    
    private func promptForPassword() {
        let passwordVerifyViewController = PasswordVerifyViewController()
        passwordVerifyViewController.verificationDelegate = self
        passwordVerifyViewController.modalPresentationStyle = .fullScreen
        passwordVerifyViewController.isModalInPresentation = true
        window?.rootViewController?.present(passwordVerifyViewController, animated: false, completion: nil)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        coverViewManager?.addCoverView()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        coverViewManager?.addCoverView()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if coverViewManager?.hasCoverView() == true {
            self.authenticateUser()
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if coverViewManager?.hasCoverView() == true {
            self.authenticateUser()
        }
    }
}


extension SceneDelegate: PasswordVerifyViewControllerDelegate, PasswordRegistrationViewControllerDelegate, PasswordRegistrationSuccessViewControllerDelegate, LaunchScreenViewControllerDelegate, LoginViewControllerDelegate {
    
    // PasswordVerifyViewControllerDelegate
    func passwordVerificationDidFinish(success: Bool) {
        if success {
            if AppStateManager.shared.isBegin {
                AppStateManager.shared.isBegin.toggle()
                showMainView()
            } else {
                self.coverViewManager?.removeCoverView()
            }
        }
    }
    
    // PasswordRegistrationViewControllerDelegate
    func passwordRegistDidFinish(success: Bool, error: Error?) {
        if success {
            showLoginSuccessView()
        } else {
            print("비밀번로 등록 실패: \(String(describing: error?.localizedDescription))")
        }
    }
    
    // PasswordRegistrationSuccessViewControllerDelegate
    func userRegistDidFinish(success: Bool, error: Error?) {
        if success {
            showMainView()
        } else {
            print("전체 로그인 실패: \(String(describing: error?.localizedDescription))")
        }
    }
    
    // LaunchScreenViewControllerDelegate
    func launchScreenDidFinish() {
        let authService = AuthenticationManager()
        if authService.isUserLoggedIn() {
            if !authService.isSettingUserPassword() {
                showPasswordRegistrationView()
            } else {
                // 앱 처음 진입시
                self.authenticateUser()
            }
        } else {
            showLoginView()
        }
    }
    
    // LoginViewControllerDelegate
    func oauthLoginDidFinish(success: Bool, error: Error?) {
        if success {
            showPasswordRegistrationView()
        } else {
            print("로그인 실패: \(String(describing: error?.localizedDescription))")
        }
    }
}

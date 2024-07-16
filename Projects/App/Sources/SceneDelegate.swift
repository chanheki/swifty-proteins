//
//  SceneDelegate.swift
//  SwiftyProteins
//
//  Created by Chan on 3/28/24.
//

import UIKit

import CoreCoreDataProvider
import DomainAuthentication
import Feature

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coverViewManager: CoverViewManager?
    var authenticationFlow: AuthenticationFlow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserLogout), name: NSNotification.Name("UserDidLogout"), object: nil)
        
        window = UIWindow(windowScene: windowScene)
        
        let launchScreenViewController = LaunchScreenViewController()
        launchScreenViewController.delegate = self
        window?.rootViewController = launchScreenViewController
        window?.makeKeyAndVisible()
        
        coverViewManager = CoverViewManager(window: window)
        authenticationFlow = AuthenticationFlow()
    }
    
    func showMainView() {
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
        AppStateManager.shared.isShowPasswordPrompt = true
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
        if coverViewManager?.hasCoverView() == true && !AppStateManager.shared.isBegin {
            self.authenticateUser()
        }
    }
    
    @objc private func handleUserLogout() {
        showLoginView()
        AppStateManager.shared.isPossibleCoverView = false
    }
}


extension SceneDelegate: PasswordVerifyViewControllerDelegate, PasswordRegistrationViewControllerDelegate, PasswordRegistrationSuccessViewControllerDelegate, LaunchScreenViewControllerDelegate, LoginViewControllerDelegate {
    
    // PasswordVerifyViewControllerDelegate
    func passwordVerificationDidFinish(success: Bool) {
        AppStateManager.shared.isShowPasswordPrompt = false
        if success {
            if AppStateManager.shared.isBegin {
                AppStateManager.shared.isBegin.toggle()
                print("첫 시작 검증 끝나고 showMainView()")
                showMainView()
            } else {
                self.coverViewManager?.removeCoverView()
            }
        }
    }
    
    // PasswordRegistrationViewControllerDelegate
    func passwordRegistDidFinish(success: Bool, error: Error?) {
        if success {
            print("비밀번호 등록 성공")
            showLoginSuccessView()
        } else {
            print("비밀번로 등록 실패: \(String(describing: error?.localizedDescription))")
            showLoginView()
        }
    }
    
    // PasswordRegistrationSuccessViewControllerDelegate
    func userRegistDidFinish(success: Bool, error: Error?) {
        if success {
            print("전체 로그인 성공")
            showMainView()
            AppStateManager.shared.isPossibleCoverView = true
        } else {
            print("전체 로그인 실패: \(String(describing: error?.localizedDescription))")
            showLoginView()
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
            print("로그인 성공: \(String(describing: error?.localizedDescription))")
            showPasswordRegistrationView()
            AppStateManager.shared.isLoggedIn = true
        } else {
            print("로그인 실패: \(String(describing: error?.localizedDescription))")
            showLoginView()
        }
    }
}

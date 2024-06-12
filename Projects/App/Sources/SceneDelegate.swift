//
//  SceneDelegate.swift
//  SwiftyProteins
//
//  Created by Chan on 3/28/24.
//

import UIKit
import AuthenticationServices
import CoreData

import Firebase
import GoogleSignIn
import Lottie


import Feature
import FeatureAuthenticationInterface
import SharedCommonUI
import DomainAuthentication



extension SceneDelegate: PasswordRegistrationViewControllerDelegate {
    func passwordRegistDidFinish(success: Bool, error: Error?) {
        if success {
            // 로그인 성공 후 메인 화면 표시 로직 구현
            print("비밀번호 등록 성공")
            showLoginSuccessView()
            
        } else {
            // 오류 처리 로직 구현
            print("비밀번로 등록 실패: \(String(describing: error?.localizedDescription))")
        }
    }
}

extension SceneDelegate: PasswordRegistrationSuccessViewControllerDelegate {
    func userRegistDidFinish(success: Bool, error: Error?) {
        if success {
            // 로그인 성공 후 메인 화면 표시 로직 구현
            print("전체 로그인 성공")
            showMainView()
            
        } else {
            // 오류 처리 로직 구현
            print("전체 로그인 실패: \(String(describing: error?.localizedDescription))")
        }
    }
}

extension SceneDelegate: LaunchScreenViewControllerDelegate, LoginViewControllerDelegate {
    // LaunchScreenViewControllerDelegate
    func launchScreenDidFinish() {
        
        //        CoreDataProvider.shared.clearCoreData()
        // 로그인 상태 확인 후 적절한 인증 절차 진행
        let authService = AuthenticationManager()
        if authService.isUserLoggedIn() {
            showMainView()
        } else {
                        showLoginView()
//            moveToPasswordRegisteration()
        }
    }
    
    func oauthLoginDidFinish(success: Bool, error: Error?) {
        if success {
            // 로그인 성공 후 메인 화면 표시 로직 구현
            print("로그인 성공")
            showPasswordRegistrationView()
        } else {
            // 오류 처리 로직 구현
            print("로그인 실패: \(String(describing: error?.localizedDescription))")
        }
    }
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coverViewManager: CoverViewManager?
    var biometricFlow: BiometricAuthenticationFlow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // custom launchscreen
        let launchScreenViewController = LaunchScreenViewController()
        launchScreenViewController.delegate = self
        window?.rootViewController = launchScreenViewController
        window?.makeKeyAndVisible()
    }
    
    func showMainView() {
        // protein list view
        let initialViewController = ProteinsListViewController()
        
        window?.rootViewController = initialViewController.initialView()
        window?.makeKeyAndVisible()
        
        // 커버 뷰 관리 및 바이오메트릭 인증 플로우 초기화
        coverViewManager = CoverViewManager(window: window)
        biometricFlow = BiometricAuthenticationFlow(window: window)
        
        // 처음 앱 실행 시 커버 뷰를 추가 및 인증 시작
        coverViewManager?.addCoverView()
        
        self.authenticateUser()
    }
    
    func showLoginView() {
        let authService = AuthenticationManager()

        // 로그인 뷰 컨트롤러 생성 및 설정
        let loginViewController = LoginViewController(authService: authService)
        loginViewController.delegate = self // 로그인 성공 후 콜백 처리를 위해 델리게이트 설정 필요
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
        loginSuccessViewController.delegate = self // 로그인 성공 후 콜백 처리를 위해 델리게이트 설정 필요
        window?.rootViewController = loginSuccessViewController
        window?.makeKeyAndVisible()
    }
    
    private func authenticateUser() {
        biometricFlow?.start { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    // 앱 정상 실행 Flow Feature
                    self?.coverViewManager?.removeCoverView()
                } else {
                    // 앱 꺼짐 혹은 재시도 Flow Feature
//                    self?.biometricFlow?.showFailureViewController(error: error)
                }
            }
        }
    }
    
    func moveToPasswordRegisteration() {
        // 비밀번호 등록 뷰 컨트롤러 생성
//        let PasswordRegistrationViewController = PasswordRegistrationViewController()
//        PasswordRegistrationViewController.delegate = self
//        // 비밀번호 등록 뷰 컨트롤러로 이동
//        window?.rootViewController = PasswordRegistrationViewController
//        window?.makeKeyAndVisible()
        
//        let UnsubscribeViewController = DeleteAccountViewController()
//        UnsubscribeViewController.delegate = self
//        window?.rootViewController = UnsubscribeViewController
//        window?.makeKeyAndVisible()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // 홈 버튼 두 번 눌러 앱이 비활성화될 때 커버 뷰 추가
        coverViewManager?.addCoverView()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // 대기 모드 진입 시 커버 뷰 추가
        coverViewManager?.addCoverView()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // 다시 활성화될 때 인증 로직 호출
        if coverViewManager?.hasCoverView() == true {
            self.authenticateUser()
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // 다시 활성화될 때 인증 로직 호출
        if coverViewManager?.hasCoverView() == true {
            self.authenticateUser()
        }
    }
    
    //    func signInOAuthView(_ scene: UIScene) {
    //        oauthViewManager?.
    //    }
    
    
    
}

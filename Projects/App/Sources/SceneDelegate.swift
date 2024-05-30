//
//  SceneDelegate.swift
//  SwiftyProteins
//
//  Created by Chan on 3/28/24.
//

import UIKit

import Feature
import SharedCommonUI


extension SceneDelegate: LaunchScreenViewControllerDelegate {
    func launchScreenDidFinish() {
        showMainView()
    }
}

// LaunchScreenViewControllerDelegate 프로토콜 정의
protocol LaunchScreenViewControllerDelegate: AnyObject {
    func launchScreenDidFinish()
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
    
    private func authenticateUser() {
        biometricFlow?.start { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    // 앱 정상 실행 Flow Feature
                    self?.coverViewManager?.removeCoverView()
                } else {
                    // 앱 꺼짐 혹은 재시도 Flow Feature
                    self?.biometricFlow?.showFailureViewController(error: error)
                }
            }
        }
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
}

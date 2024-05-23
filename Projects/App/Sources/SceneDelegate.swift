//
//  SceneDelegate.swift
//  SwiftyProteins
//
//  Created by Chan on 3/28/24.
//

import UIKit

import Feature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let initialViewController = ProteinsListViewController()
        
        window?.rootViewController = initialViewController.initialView()
        window?.makeKeyAndVisible()
        
        authenticateUser()
    }
    
    private func authenticateUser() {
        // 바이오메트릭 인증 로직
        let biometricFlow = BiometricAuthenticationFlow(window: window)
        
        biometricFlow.start { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    // 앱 정상 실행 Flow Feature
                    self?.showMainViewController()
                } else {
                    // 앱 꺼짐 혹은 재시도 Flow Feature
                    biometricFlow.showFailureViewController(error: error)
                }
            }
        }
    }
    
    private func showMainViewController() {
        // 메인 뷰 컨트롤러를 표시하는 로직이 필요한 경우 여기에 추가
        // 현재 예시에서는 초기 설정 시 이미 메인 뷰 컨트롤러를 설정했기 때문에 별도의 로직이 필요 없습니다.
    }
}

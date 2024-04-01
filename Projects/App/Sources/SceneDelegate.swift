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
        
        // 앱 진입 Launch Screen 으로 변경해줘야함
        let mainViewController = UIViewController()
        mainViewController.view.backgroundColor = .blue
        
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
        let biometricFlow = BiometricAuthenticationFlow(window: window)
        
        biometricFlow.start { success, error in
            DispatchQueue.main.async {
                if success {
                    // 앱 정상 실행 Flow Feature
                    biometricFlow.showMainViewController()
                } else {
                    // 앱 꺼짐 혹은 재시도 Flow Feature
                    biometricFlow.showFailureViewController(error: error)
                }
            }
        }
    }
}

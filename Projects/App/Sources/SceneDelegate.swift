//
//  SceneDelegate.swift
//  SwiftyProteins
//
//  Created by Chan on 3/28/24.
//

import UIKit
import LocalAuthentication
import LocalAuthenticationEmbeddedUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let viewController = UIViewController()
        viewController.view.backgroundColor = .orange
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

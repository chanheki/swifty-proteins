//
//  LoginViewController.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/2/24.
//

import UIKit
import CoreData
import AuthenticationServices

import GoogleSignIn

import FeatureAuthenticationInterface
import CoreAuthentication
import CoreCoreDataProvider
import SharedCommonUI

//public final class LoginViewController: UIViewController {
    
//    // Delegate property
//    public weak var delegate: LoginViewControllerDelegate?
    
//    // Google 로그인 버튼
//    private var googleLoginButton: GIDSignInButton!
//    private var AppleLoginButton: ASAuthorizationAppleIDButton!
//    private var loginLabel: UILabel!
    
//    public override func viewDidLoad() {
//        super.viewDidLoad()
        
//        setupProperties()
//        setupLoginLabel()
//        setupGoogleLoginButton()
//        setupAppleLoginButton()
//        setupView()
//    }
    
//    private func setupProperties() {
//        view.backgroundColor = .backgroundColor
//    }
    
//    private func setupLoginLabel() {
//        self.loginLabel = UILabel()
//        self.loginLabel.text = "Swifty Proteins"
//        self.loginLabel.textAlignment = .center
//        self.loginLabel.font = UIFontMetrics(forTextStyle: .title1)
//            .scaledFont(for: UIFont.systemFont(ofSize: 36, weight: .bold))
//        self.loginLabel.textColor = .foregroundColor
//        self.loginLabel.translatesAutoresizingMaskIntoConstraints = false
//    }
    
//    private func setupGoogleLoginButton() {
//        self.googleLoginButton = GIDSignInButton()
//        self.googleLoginButton.colorScheme = .dark
//        self.googleLoginButton.style = .wide
//        self.googleLoginButton.addTarget(self, action: #selector(startGoogleSignIn), for: .touchUpInside)
//        self.googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
//    }
    
//    private func setupAppleLoginButton() {
//        self.AppleLoginButton = ASAuthorizationAppleIDButton()
//        self.AppleLoginButton.addTarget(self, action: #selector(startAppleSignIn), for: .touchUpInside)
//        self.AppleLoginButton.translatesAutoresizingMaskIntoConstraints = false
//    }
    
//    private func setupView() {
//        view.addSubview(self.loginLabel)
//        view.addSubview(self.googleLoginButton)
//        view.addSubview(self.AppleLoginButton)
        
//        NSLayoutConstraint.activate([
//            self.loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            self.loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height / 5),
            
//            self.googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            self.googleLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height * 0.66),
//            self.googleLoginButton.widthAnchor.constraint(equalToConstant: 280),
//            self.googleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            
//            self.AppleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            self.AppleLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 20),
//            self.AppleLoginButton.widthAnchor.constraint(equalToConstant: 280),
//            self.AppleLoginButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
    
//    @objc private func startGoogleSignIn() {
//        DispatchQueue.main.async {
//            GoogleOAuthManager.shared.startGoogleSignIn(presenting: self) { [weak self] success, error in
//                if let error = error {
//                    self?.delegate?.loginDidFinish(success: false, error: error)
//                    return
//                }
                
//                self?.delegate?.loginDidFinish(success: true, error: nil)
//            }
//        }
//    }
    
//    @objc private func startAppleSignIn() {
//        // Apple Sign-In 로직을 추가합니다.
//    }
//}

public final class LoginViewController: UIViewController {
    
    // Delegate property
    public weak var delegate: LoginViewControllerDelegate?
    
    // Google 로그인 버튼
    private var googleLoginButton = GIDSignInButton() // UIButton 대신 GIDSignInButton 사용
    private var AppleLoginButton = ASAuthorizationAppleIDButton()
    private var loginLabel = UILabel()
    private var landscapeConstraints: [NSLayoutConstraint] = []
    private var portraitContraints: [NSLayoutConstraint] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLoginLabel()
        setupGoogleLoginButton()
        setupAppleLoginButton()
        setUpView()
        
        // 화면 방향 변경 알림 등록
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleOrientationChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )

        // 초기 화면 방향에 맞춰 제약 조건 적용
        handleOrientationChange()
    }

    @objc private func handleOrientationChange() {
        if interfaceOrientation.isPortrait {
            applyPortraitConstraints()
        } else {
            applyLandscapeConstraints()
        }
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
                self?.applyPortraitConstraints()
            } else {
                self?.applyLandscapeConstraints()
            }
        }, completion: nil)
    }

    // 세로 화면
    func applyPortraitConstraints() {
        NSLayoutConstraint.deactivate(self.landscapeConstraints)
        NSLayoutConstraint.activate(self.portraitContraints)
    }

    // 가로 화면
    func applyLandscapeConstraints() {
        NSLayoutConstraint.deactivate(self.portraitContraints)
        NSLayoutConstraint.activate(self.landscapeConstraints)
    }
    
    private func setUpView() {
        // 포트레이트 모드에 대한 제약 조건 설정
        self.portraitContraints = [
            // 예시:
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height / 5),
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height * 0.66), // 하단 1/3 지점에 위치
            googleLoginButton.widthAnchor.constraint(equalToConstant: 250), // 버튼의 너비를 280포인트로 설정
            googleLoginButton.heightAnchor.constraint(equalToConstant: 48), // 버튼의 높이를 50포인트로 설정
            AppleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            AppleLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor), // Google 로그인 버튼 아래에 20포인트 간격을 두고 위치
            AppleLoginButton.widthAnchor.constraint(equalToConstant: 250), // 버튼의 너비를 280포인트로 설정
            AppleLoginButton.heightAnchor.constraint(equalToConstant: 48) // 버튼의 높이를 50포인트로 설정
        ]
        
        // 랜드스케이프 모드에 대한 제약 조건 설정
        self.landscapeConstraints = [
            // 예시:
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.width / 5),
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.width * 0.66), // 하단 1/3 지점에 위치
            googleLoginButton.widthAnchor.constraint(equalToConstant: 250), // 버튼의 너비를 280포인트로 설정
            googleLoginButton.heightAnchor.constraint(equalToConstant: 48), // 버튼의 높이를 50포인트로 설정
            AppleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            AppleLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor), // Google 로그인 버튼 아래에 20포인트 간격을 두고 위치
            AppleLoginButton.widthAnchor.constraint(equalToConstant: 250), // 버튼의 너비를 280포인트로 설정
            AppleLoginButton.heightAnchor.constraint(equalToConstant: 48) // 버튼의 높이를 50포인트로 설정
        ]
    }
    
    private func setupLoginLabel() {
        loginLabel.text = "Swifty Proteins"
        loginLabel.textAlignment = .center
        loginLabel.font = UIFontMetrics(forTextStyle: .title1)
            .scaledFont(for: UIFont.systemFont(ofSize: 36, weight: .bold))
        loginLabel.textColor = .foregroundColor
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel) // 뷰에 라벨 추가하는 부분이 빠져있어서 추가했습니다.
    }

    private func setupGoogleLoginButton() {
        // Google 로그인 버튼 설정
        googleLoginButton.colorScheme = .dark
        googleLoginButton.style = .wide // 버튼 스타일 설정, 필요에 따라 변경 가능
        googleLoginButton.addTarget(self, action: #selector(startGoogleSignIn), for: .touchUpInside)
        
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleLoginButton)
    }
    
    private func setupAppleLoginButton() {
        // Apple 로그인 버튼 설정
        AppleLoginButton.addTarget(self, action: #selector(startAppleSignIn), for: .touchUpInside)
        AppleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(AppleLoginButton)
    }
    
    
    @objc private func startGoogleSignIn() {
        DispatchQueue.main.async {
            GoogleOAuthManager.shared.startGoogleSignIn(presenting: self) { [weak self] success, error in
                if let error = error {
                    self?.delegate?.oauthLoginDidFinish(success: true, error: nil)
                    return
                }
                
                self?.delegate?.oauthLoginDidFinish(success: true, error: nil)
            }
        }
    }
    
    @objc private func startAppleSignIn() {
    }
}

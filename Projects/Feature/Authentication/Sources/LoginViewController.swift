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
import DomainAuthenticationInterface
import CoreAuthentication
import CoreCoreDataProvider
import SharedCommonUI
import SharedDesignSystem
import Firebase


public final class LoginViewController: UIViewController {
    
    // Delegate property
    public weak var delegate: LoginViewControllerDelegate?
    
    // AuthenticationService property
    private var authService: AuthenticationService
    
    // Google 로그인 버튼
    private var googleLoginButton: UIButton!
    private var AppleLoginButton: ASAuthorizationAppleIDButton!
    private var loginLabel: UILabel!
    private var portraitContraints: [NSLayoutConstraint]!
    private var landscapeConstraints: [NSLayoutConstraint]!
    
    // 생성자에서 authService를 주입받음
    public init(authService: AuthenticationService) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        loginLabel = UILabel()
        loginLabel.text = "Swifty Proteins"
        loginLabel.textAlignment = .center
        loginLabel.font = UIFontMetrics(forTextStyle: .title1)
            .scaledFont(for: UIFont.systemFont(ofSize: 36, weight: .bold))
        loginLabel.textColor = .foregroundColor
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel) // 뷰에 라벨 추가하는 부분이 빠져있어서 추가했습니다.
    }

    private func setupGoogleLoginButton() {
        googleLoginButton = UIButton(type: .system)
        let googleLogoImage = SharedDesignSystem.GoogleLogo
        googleLoginButton.setImage(googleLogoImage, for: .normal)
        googleLoginButton.setTitle(" Sign in with Google", for: .normal)
        googleLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        googleLoginButton.tintColor = .gray
        googleLoginButton.backgroundColor = .white
        googleLoginButton.layer.cornerRadius = 8
        googleLoginButton.layer.borderWidth = 0.5 // 테두리 두께 설정
        googleLoginButton.layer.borderColor = UIColor.gray.cgColor // 테두리 색상 설정
        googleLoginButton.addTarget(self, action: #selector(startGoogleSignIn), for: .touchUpInside)
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleLoginButton)
    }

    
    private func setupAppleLoginButton() {
        // Apple 로그인 버튼 설정
        AppleLoginButton = ASAuthorizationAppleIDButton()
        AppleLoginButton.addTarget(self, action: #selector(startAppleSignIn), for: .touchUpInside)
        AppleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(AppleLoginButton)
    }
    
    
    @objc private func startGoogleSignIn() {
        DispatchQueue.main.async {
            GoogleOAuthManager.shared.startGoogleSignIn(presenting: self) { [weak self] success, error in
                if let error = error {
                    self?.delegate?.oauthLoginDidFinish(success: false, error: error)
                    return
                }
                
                self?.delegate?.oauthLoginDidFinish(success: true, error: nil)
            }
        }
    }
    
    @objc private func startAppleSignIn() {
        DispatchQueue.main.async {
            self.authService.appleSignIn(presentingViewController: self) { [weak self] success, error in
                if let error = error {
                    self?.delegate?.oauthLoginDidFinish(success: false, error: error)
                    return
                }
                
                self?.delegate?.oauthLoginDidFinish(success: true, error: nil)
            }
        }
    }
    
}

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

public final class LoginViewController: UIViewController {
    
    // Delegate property
    public weak var delegate: LoginViewControllerDelegate?
    
    // AuthenticationService property
    private var authService: AuthenticationService
    
    // Google 로그인 버튼
    private var googleLoginButton: GIDSignInButton!
    private var AppleLoginButton: ASAuthorizationAppleIDButton!
    private var loginLabel: UILabel!
    
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
        
        setupProperties()
        setupLoginLabel()
        setupGoogleLoginButton()
        setupAppleLoginButton()
        setupView()
    }
    
    private func setupProperties() {
        view.backgroundColor = .backgroundColor
    }
    
    private func setupLoginLabel() {
        self.loginLabel = UILabel()
        self.loginLabel.text = "Swifty Proteins"
        self.loginLabel.textAlignment = .center
        self.loginLabel.font = UIFontMetrics(forTextStyle: .title1)
            .scaledFont(for: UIFont.systemFont(ofSize: 36, weight: .bold))
        self.loginLabel.textColor = .foregroundColor
        self.loginLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupGoogleLoginButton() {
        self.googleLoginButton = GIDSignInButton()
        self.googleLoginButton.colorScheme = .dark
        self.googleLoginButton.style = .wide
        self.googleLoginButton.addTarget(self, action: #selector(startGoogleSignIn), for: .touchUpInside)
        self.googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupAppleLoginButton() {
        self.AppleLoginButton = ASAuthorizationAppleIDButton()
        self.AppleLoginButton.addTarget(self, action: #selector(startAppleSignIn), for: .touchUpInside)
        self.AppleLoginButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupView() {
        view.addSubview(self.loginLabel)
        view.addSubview(self.googleLoginButton)
        view.addSubview(self.AppleLoginButton)
        
        NSLayoutConstraint.activate([
            self.loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height / 5),
            
            self.googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.googleLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height * 0.66),
            self.googleLoginButton.widthAnchor.constraint(equalToConstant: 280),
            self.googleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.AppleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.AppleLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 20),
            self.AppleLoginButton.widthAnchor.constraint(equalToConstant: 280),
            self.AppleLoginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func startGoogleSignIn() {
        DispatchQueue.main.async {
            GoogleOAuthManager.shared.startGoogleSignIn(presenting: self) { [weak self] success, error in
                if let error = error {
                    self?.delegate?.loginDidFinish(success: false, error: error)
                    return
                }
                
                self?.delegate?.loginDidFinish(success: true, error: nil)
            }
        }
    }
    
    @objc private func startAppleSignIn() {
        DispatchQueue.main.async {
            self.authService.appleSignIn(presentingViewController: self) { [weak self] success, error in
                if let error = error {
                    self?.delegate?.loginDidFinish(success: false, error: error)
                    return
                }
                
                self?.delegate?.loginDidFinish(success: true, error: nil)
            }
        }
    }
    
}

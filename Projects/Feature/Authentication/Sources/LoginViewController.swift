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

public final class LoginViewController: UIViewController {
    
    public weak var delegate: LoginViewControllerDelegate?
    
    private var authService: AuthenticationService
    
    private var loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "Swifty Proteins"
        loginLabel.textAlignment = .center
        loginLabel.font = UIFontMetrics(forTextStyle: .title1)
            .scaledFont(for: UIFont.systemFont(ofSize: 36, weight: .bold))
        loginLabel.textColor = .foregroundColor
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginLabel
    }()
    
    private var googleLoginButton: UIButton = {
        let googleLoginButton = UIButton(type: .system)
        let googleLogoImage = SharedDesignSystem.GoogleLogo
        googleLoginButton.setImage(googleLogoImage, for: .normal)
        googleLoginButton.setTitle(" Sign in with Google", for: .normal)
        googleLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        googleLoginButton.tintColor = .gray
        googleLoginButton.backgroundColor = .white
        googleLoginButton.layer.cornerRadius = 5
        googleLoginButton.layer.borderWidth = 0.5
        googleLoginButton.layer.borderColor = UIColor.gray.cgColor
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        return googleLoginButton
    }()
    
    lazy private var appleLoginButton: ASAuthorizationAppleIDButton =  {
        let appleLoginButton = ASAuthorizationAppleIDButton()
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        return appleLoginButton
    }()
    
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    
    public init(authService: AuthenticationService) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupProperty()
        setUpView()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.applyConstraints(for: size)
        })
    }
    
    private func setupProperty() {
        self.view.backgroundColor = .backgroundColor
        
        googleLoginButton.addTarget(self, action: #selector(startGoogleSignIn), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(startAppleSignIn), for: .touchUpInside)
    }
    
    private func applyConstraints(for size: CGSize) {
        if size.width > size.height {
            NSLayoutConstraint.deactivate(self.portraitConstraints)
            NSLayoutConstraint.activate(self.landscapeConstraints)
        } else {
            NSLayoutConstraint.deactivate(self.landscapeConstraints)
            NSLayoutConstraint.activate(self.portraitConstraints)
        }
    }
    
    private func setUpView() {
        view.addSubview(loginLabel)
        view.addSubview(googleLoginButton)
        view.addSubview(appleLoginButton)
        
        initConstraints()
        applyConstraints(for: view.bounds.size)
        
    }
    
    private func initConstraints() {
        self.portraitConstraints = [
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height / 5),
            
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height * 0.66),
            googleLoginButton.widthAnchor.constraint(equalToConstant: 250),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 48),
            
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 10),
            appleLoginButton.widthAnchor.constraint(equalToConstant: 250),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 48)
        ]
        
        self.landscapeConstraints = [
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.width / 5),
            
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.width * 0.66),
            googleLoginButton.widthAnchor.constraint(equalToConstant: 250),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 48),
            
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 10),
            appleLoginButton.widthAnchor.constraint(equalToConstant: 250),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 48)
        ]
    }
    
    @objc private func startGoogleSignIn() {
        DispatchQueue.main.async {
            GoogleOAuthManager.shared.startGoogleSignIn(presenting: self) { [weak self] success, error in
                if let error = error {
                    self?.delegate?.oauthLoginDidFinish(success: false, error: error)
                    return
                }
                
                self?.delegate?.oauthLoginDidFinish(success: success, error: nil)
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


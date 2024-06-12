//
//  UnsubscribeViewController.swift
//  FeatureAuthentication
//
//  Created by 민영재 on 6/11/24.
//

import UIKit

import DomainAuthentication
import FeatureAuthenticationInterface

import SharedCommonUI

public class DeleteAccountViewController: UIViewController {
    
    public weak var delegate: PasswordRegistrationViewControllerDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Delete Account"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Do you want to Delete Account?"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("comfirm", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var noButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("cancel", for: .normal)
        button.setTitleColor(.foregroundColor, for: .normal)
        button.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(yesButton)
        buttonStackView.addArrangedSubview(noButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            
            messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            
            buttonStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            
            yesButton.widthAnchor.constraint(equalToConstant: 80),
            noButton.widthAnchor.constraint(equalToConstant: 80),
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8),
            containerView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2),
            
        ])
    }
    
    @objc private func yesButtonTapped() {
        // 회원 탈퇴 API 호출
        // 성공 시 아래 코드 실행
        presentUnsubscribeSuccessView()
    }
    
    @objc private func noButtonTapped() {
        // 아니오 버튼 클릭 시 처리
        navigationController?.popViewController(animated: true)
    }
    
    private func presentUnsubscribeSuccessView() {
        let authService = AuthenticationManager()
        let loginViewController = LoginViewController(authService: authService)
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}



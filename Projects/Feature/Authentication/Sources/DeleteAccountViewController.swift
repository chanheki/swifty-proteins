//
//  DeleteAccountViewController.swift
//  FeatureAuthentication
//
//  Created by 민영재 on 6/11/24.
//

import UIKit

import DomainAuthentication
import FeatureAuthenticationInterface

import SharedCommonUI

public class DeleteAccountViewController: UIView {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Do you want to delete account? Really..?."
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        
        addSubview(messageLabel)
        addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            confirmButton.widthAnchor.constraint(equalToConstant: 100),
            confirmButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // 확인 버튼 클릭 이벤트 추가
        confirmButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        // 화면 밖 터치 시 뷰 사라지게 하는 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissView() {
        self.removeFromSuperview()
    }
}



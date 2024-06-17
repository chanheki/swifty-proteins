//
//  UserInfoViewController.swift
//  FeatureAuthentication
//
//  Created by 민영재 on 6/11/24.
//

import UIKit
import CoreData

import CoreAuthentication
import SharedCommonUI

public class UserInfoViewController: UIViewController {
    
    private var userInfo: [String: Any]?
    
    // UI elements
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let ageLabel = UILabel()
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchUserInfo()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(ageLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ageLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            ageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    private func fetchUserInfo() {
        GoogleOAuthManager.shared.firebaseFetch { [weak self] userInfo, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to fetch user info: \(error.localizedDescription)")
                // 추가적으로 에러를 처리할 수 있는 코드 작성 가능
                return
            }
            
            if let userInfo = userInfo {
                self.userInfo = userInfo
                self.updateUI()
            } else {
                print("Failed to fetch user info: No data found")
            }
        }
    }
    
    private func updateUI() {
        guard let userInfo = self.userInfo else {
            return
        }
        
        nameLabel.text = "Name: \(userInfo["name"] as? String ?? "")"
        emailLabel.text = "Email: \(userInfo["email"] as? String ?? "")"
        ageLabel.text = "Age: \(userInfo["age"] as? Int ?? 0)"
    }
}

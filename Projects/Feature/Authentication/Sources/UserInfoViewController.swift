//
//  UserInfoViewController.swift
//  FeatureAuthentication
//
//  Created by 민영재 on 6/11/24.
//

import UIKit
import CoreData

import CoreAuthentication

public class UserInfoViewController: UIViewController {
    
    private var userInfo: [String: Any]?
    
    // UI elements
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let ageLabel = UILabel()
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up UI elements
        setupUI()
        
        // Fetch user information from Firestore
        fetchUserInfo()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add labels to the view
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(ageLabel)
        
        // Configure constraints for the labels
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints for the labels
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
        // Fetch the current user's document from Firestore
        if let currentUser = GoogleOAuthManager.shared.firebaseFetch() {
            self.userInfo = currentUser
            updateUI()
        } else {
            print("Failed to fetch user info")
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

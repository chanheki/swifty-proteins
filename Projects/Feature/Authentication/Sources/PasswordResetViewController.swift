//
//  PasswordResetViewController.swift
//  FeatureAuthentication
//
//  Created by 민영재 on 6/13/24.
//

import UIKit
import CoreData

import CoreAuthentication
import CoreCoreDataProvider

import FeatureAuthenticationInterface

public class PasswordResetViewController: PasswordRegistrationViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func appendToPasswordField(_ digit: String) {
        if passwordTextField.isHidden == false {
            if passwordTextField.text?.count ?? 0 < 4 {
                passwordTextField.text?.append(digit)
                if passwordTextField.text?.count == 4 {
                    // 비밀번호 확인 뷰로 넘어가는 로직 추가
                    passwordTextField.isHidden = true
                    passwordConfirmedTextField.isHidden = false
                }
            }
        }else {
            if passwordConfirmedTextField.text?.count ?? 0 < 4 {
                passwordConfirmedTextField.text?.append(digit)
                if passwordConfirmedTextField.text?.count == 4 {
                    // 비밀번호 검증 로직
                    if passwordTextField.text == passwordConfirmedTextField.text {
                        //CoreData 저장 및 MainView 이동
                        CoreDataProvider.shared.updatePasswordForCurrentUser(password: passwordTextField.text!)
                        self.delegate?
                            .passwordRegistDidFinish(success: true, error: nil)
                        
                    } else {
                        // 비밀번호 등록 실패 시 PasswordRegistrationFailureView 보여주기
                        let failureView = PasswordRegistrationFailureView(frame: self.view.bounds)
                        self.view.addSubview(failureView)
                        failureView.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                            failureView.topAnchor.constraint(equalTo: self.view.topAnchor),
                            failureView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                            failureView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                            failureView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
                        ])
                        
                        passwordTextField.isHidden = false
                        passwordConfirmedTextField.isHidden = true
                        passwordTextField.text?.removeAll()
                        passwordConfirmedTextField.text?.removeAll()
                    }
                }
            }
        }
    }
}

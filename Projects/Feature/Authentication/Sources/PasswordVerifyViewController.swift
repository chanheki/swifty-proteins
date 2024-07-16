//
//  PasswordVerifyViewController.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/9/24.
//

import UIKit

import CoreCoreDataProvider
import FeatureAuthenticationInterface

public final class PasswordVerifyViewController: PasswordRegistrationViewController {
    weak public var verificationDelegate: PasswordVerifyViewControllerDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupVerifyUI()
    }
    
    public override func appendToPasswordField(_ digit: String) {
        guard let text = passwordTextField.text, text.count < 4 else {
            return
        }
        
        passwordTextField.text?.append(digit)
        
        if passwordTextField.text?.count == 4 {
            verifyPassword()
        }
    }
    
    private func verifyPassword() {
        guard let password = passwordTextField.text else { return }
        
        if CoreDataProvider.shared.isRightPassword(password: password) {
            passwordSuccess()
        } else {
            passwordFailure()
        }
    }
    
    public override func setupUI() {
        super.setupUI()
        passwordTextField.placeholder = ""
    }
    
    private func setupVerifyUI() {
        super.setupUI()
        passwordTextField.setPlaceholder(text: "비밀번호 입력", color: .gray)
    }
    
    private func passwordSuccess() {
        verificationDelegate?.passwordVerificationDidFinish(success: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func passwordFailure() {
        passwordTextField.text = ""
        passwordTextField.tintColor = .red
        passwordTextField.setPlaceholder(text: "비밀번호 재입력", color: .red)

        // 흔들림 애니메이션 추가
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.values = [-10, 10, -8, 8, -6, 6, -4, 4, -2, 2, 0]
        animation.duration = 0.5
        passwordTextField.layer.add(animation, forKey: "shake")
        
        // verificationDelegate 호출
//        verificationDelegate?.passwordVerificationDidFinish(success: false)
    }

}

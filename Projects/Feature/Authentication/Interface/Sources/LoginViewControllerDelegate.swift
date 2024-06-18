//
//  LoginViewControllerDelegate.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/2/24.
//

// 로그인 성공 후 콜백 처리를 위한 프로토콜
public protocol LoginViewControllerDelegate: AnyObject {
    func oauthLoginDidFinish(success: Bool, error: Error?)
}

public protocol PasswordRegistrationViewControllerDelegate: AnyObject {
    func passwordRegistDidFinish(success: Bool, error: Error?)
}

public protocol PasswordRegistrationSuccessViewControllerDelegate: AnyObject {
    func userRegistDidFinish(success: Bool, error: Error?)
}

public protocol PasswordVerifyViewControllerDelegate: AnyObject {
    func passwordVerificationDidFinish(success: Bool)
}

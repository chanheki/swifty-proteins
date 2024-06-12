import UIKit
import CoreData
import AuthenticationServices

import FeatureAuthenticationInterface
import CoreAuthentication
import CoreCoreDataProvider
import SharedCommonUI

class PasswordVerifyViewController: PasswordRegistrationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func appendToPasswordField(_ digit: String) {
        if passwordTextField.text?.count ?? 0 < 4 {
            passwordTextField.text?.append(digit)
            if passwordTextField.text?.count == 4 {
                if CoreDataProvider.shared.isRightPassword(password: passwordTextField.text!) == true {
                    // 성공
                } else {
                    passwordTextField.text?.removeAll()
                    //에러 UIView
                }
            }
        }
    }
}

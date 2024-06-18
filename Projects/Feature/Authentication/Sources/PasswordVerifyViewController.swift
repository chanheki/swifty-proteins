import UIKit
import CoreData
import AuthenticationServices

import FeatureAuthenticationInterface
import CoreAuthentication
import CoreCoreDataProvider
import SharedCommonUI

public class PasswordVerifyViewController: PasswordRegistrationViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func appendToPasswordField(_ digit: String) {
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

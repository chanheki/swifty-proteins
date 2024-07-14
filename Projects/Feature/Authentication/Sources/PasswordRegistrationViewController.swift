import UIKit
import CoreData
import AuthenticationServices

import FeatureAuthenticationInterface
import CoreAuthentication
import CoreCoreDataProvider
import SharedCommonUI

open class PasswordRegistrationViewController: UIViewController {
    
    // MARK: - Properties
    open weak var delegate: PasswordRegistrationViewControllerDelegate?
    
    open var passwordTextField: UITextField!
    open var passwordConfirmedTextField: UITextField!
    open var passwordButtons: [UIButton] = []
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    open func setupUI() {
        view.backgroundColor = .backgroundColor
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "비밀번호 등록"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = .systemFont(ofSize: 24)
        passwordTextField.textAlignment = .center
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.inputView = UIView()
        
        passwordConfirmedTextField = UITextField()
        passwordConfirmedTextField.placeholder = "비밀번호 확인"
        passwordConfirmedTextField.isSecureTextEntry = true
        passwordConfirmedTextField.font = .systemFont(ofSize: 24)
        passwordConfirmedTextField.textAlignment = .center
        passwordConfirmedTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordConfirmedTextField.isHidden = true
        passwordConfirmedTextField.inputView = UIView()
        
        // 숫자 버튼
        let buttonSpacing: CGFloat = 16 // 버튼 간 간격 설정
        let buttonWidth = (view.frame.size.width - 48 - (buttonSpacing * 4)) / 3 // 버튼 너비 계산
        _ = buttonWidth // 버튼 높이는 너비와 같게 설정
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = buttonSpacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // passwordTextField를 담는 subStackView
        let passwordStackView = UIStackView()
        passwordStackView.axis = .vertical
        passwordStackView.addArrangedSubview(passwordTextField)
        
        // passwordConfirmedTextField를 mainStackView에 추가
        passwordStackView.addArrangedSubview(passwordConfirmedTextField)
        
        // 숫자 버튼들을 담는 subStackView
        let buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.spacing = buttonSpacing
        
        let numberButtons = [
            [7, 8, 9],
            [4, 5, 6],
            [1, 2, 3],
            [nil, 0, "취소"]
        ]
        
        for row in numberButtons {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = buttonSpacing
            
            for number in row {
                let button = UIButton(type: .system)
                if number as? String != nil {
                    let buttonImage = UIImage(systemName: "delete.left")
                    button.setImage(buttonImage, for: .normal)
                    button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
                    button.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
                    passwordButtons.append(button)
                    rowStackView.addArrangedSubview(button)
                } else if let numberString = number as? Int {
                    button.setTitle(String(numberString), for: .normal)
                    self.setNumberButtonProperties(_button: button, _rowStackView: rowStackView)
                } else {
                    self.setNumberButtonProperties(_button: button, _rowStackView: rowStackView)
                }
                button.setTitleColor(.foregroundColor, for: .normal)
                button.backgroundColor = .backgroundColor
                button.layer.cornerRadius = buttonWidth / 2
                button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
                button.tintColor = .foregroundColor
            }
            
            buttonStackView.addArrangedSubview(rowStackView)
        }
        
        mainStackView.addArrangedSubview(passwordStackView)
        mainStackView.addArrangedSubview(buttonStackView)
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    open func setNumberButtonProperties(_button : UIButton, _rowStackView : UIStackView) {
        _button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        _button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        passwordButtons.append(_button)
        _rowStackView.addArrangedSubview(_button)
    }
    
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text else { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        appendToPasswordField(number)
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        deleteFromPasswordField()
    }
    
    public func appendToPasswordField(_ digit: String) {
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
                        if CoreDataProvider.shared.updatePasswordForCurrentUser(password: passwordTextField.text!) {
                            self.delegate?.passwordRegistDidFinish(success: true, error: nil)
                        } else {
                            self.delegate?.passwordRegistDidFinish(success: false, error: nil)
                        }
                        
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
    
    public func deleteFromPasswordField() {
        if passwordTextField.isHidden == false {
            if let text = passwordTextField.text, !text.isEmpty {
                passwordTextField.text?.removeLast()
            }
        }
        else {
            if let text = passwordConfirmedTextField.text, !text.isEmpty {
                passwordConfirmedTextField.text?.removeLast()
            }
        }
    }
}

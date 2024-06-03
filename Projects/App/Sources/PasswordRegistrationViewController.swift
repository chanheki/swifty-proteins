//
//  PasswordRegistrationViewController.swift
//  SwiftyProteins
//
//  Created by 민영재 on 6/3/24.
//

//class PasswordRegistrationViewController: UIViewController {
//    
//    // MARK: - Properties
//    weak var delegate: PasswordRegistrationViewControllerDelegate?
//    
//    private var passwordTextField: UITextField!
//    private var confirmPasswordTextField: UITextField!
//    private var passwordButtons: [UIButton] = []
//    
//    // MARK: - Lifecycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//    
//    // MARK: - Private Methods
//    
//    private func setupUI() {
//        view.backgroundColor = .white
//        
//        // 비밀번호 입력 필드
//        passwordTextField = UITextField()
//        passwordTextField.placeholder = "비밀번호 입력"
//        passwordTextField.isSecureTextEntry = true
//        passwordTextField.font = .systemFont(ofSize: 24)
//        passwordTextField.textAlignment = .center
//        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
//        
//        // 숫자 버튼
//        let buttonSpacing: CGFloat = 16 // 버튼 간 간격 설정
//        let buttonWidth = (view.frame.size.width - 48 - (buttonSpacing * 4)) / 3 // 버튼 너비 계산
//        let buttonHeight = buttonWidth // 버튼 높이는 너비와 같게 설정
//        
//        let mainStackView = UIStackView()
//        mainStackView.axis = .vertical
//        mainStackView.spacing = buttonSpacing
//        mainStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // passwordTextField를 담는 subStackView
//        let passwordStackView = UIStackView()
//        passwordStackView.axis = .vertical
//        passwordStackView.addArrangedSubview(passwordTextField)
//        
//        // 숫자 버튼들을 담는 subStackView
//        let buttonStackView = UIStackView()
//        buttonStackView.axis = .vertical
//        buttonStackView.spacing = buttonSpacing
//        
//        let numberButtons = [
//            [7, 8, 9],
//            [4, 5, 6],
//            [1, 2, 3],
//            [0, "*", "취소"]
//        ]
//
//        for row in numberButtons {
//            let rowStackView = UIStackView()
//            rowStackView.axis = .horizontal
//            rowStackView.distribution = .fillEqually
//            rowStackView.spacing = buttonSpacing
//
//            for number in row {
//                let button = UIButton(type: .system)
//                if let numberString = number as? Int {
//                    button.setTitle(String(numberString), for: .normal)
//                } else {
//                    button.setTitle(String(describing: number), for: .normal)
//                }
//                button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
//                button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
//                passwordButtons.append(button)
//                rowStackView.addArrangedSubview(button)
//            }
//
//            buttonStackView.addArrangedSubview(rowStackView)
//        }
//        
//        mainStackView.addArrangedSubview(passwordStackView)
//        mainStackView.addArrangedSubview(buttonStackView)
//        
//        view.addSubview(mainStackView)
//        
//        NSLayoutConstraint.activate([
//            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
//            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
//            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
//            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
//        ])
//    }
//
//
//
//
//    @objc private func numberButtonTapped(_ sender: UIButton) {
//        guard let number = sender.titleLabel?.text else { return }
//        appendToPasswordField(number)
//    }
//    
//    @objc private func deleteButtonTapped(_ sender: UIButton) {
//        deleteFromPasswordField()
//    }
//    
//    private func appendToPasswordField(_ digit: String) {
//        if passwordTextField.text?.count ?? 0 < 4 {
//            passwordTextField.text?.append(digit)
//        }
//        
//    }
//    
//    private func deleteFromPasswordField() {
//        if let text = passwordTextField.text, !text.isEmpty {
//            passwordTextField.text?.removeLast()
//        }
//    }
//}
//

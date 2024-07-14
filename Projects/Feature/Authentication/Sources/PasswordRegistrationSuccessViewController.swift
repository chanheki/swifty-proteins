import UIKit
import CoreData
import AuthenticationServices

import Lottie

import FeatureAuthenticationInterface
import CoreAuthentication
import CoreCoreDataProvider
import SharedCommonUI
import SharedDesignSystem

open class PasswordRegistrationSuccessViewController: UIViewController {
    
    // MARK: - Properties
    public weak var delegate: PasswordRegistrationSuccessViewControllerDelegate?
    open var isAutoCloseEnabled = true
    
    // UI 요소들 선언
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 등록 완료"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 등록이 완료되었습니다.\n 10초 뒤에 자동으로 홈 화면으로 이동됩니다."
        label.textColor = .foregroundColor
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let lottieAnimationView = CheckBoxAnimationView
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.backgroundColor, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupProperty()
        setupUI()
        
        // 10초 후에 자동으로 사라지게 함
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            [weak self] in
            guard let self = self, self.isAutoCloseEnabled else { return }
            self.delegate?.userRegistDidFinish(success: true, error: nil)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showLoginCompletionUIAnimation()
    }
    
    private func showLoginCompletionUIAnimation() {
        lottieAnimationView.center = view.center
        lottieAnimationView.play()
        
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        messageLabel.alpha = 0
        messageLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        doneButton.alpha = 0
        doneButton.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: [.curveEaseInOut]) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
            self.messageLabel.alpha = 1
            self.messageLabel.transform = .identity
            self.doneButton.alpha = 1
            self.doneButton.transform = .identity
        }
    }
    
    private func handleLoginCompletionAnimation() {
        // 로그인 완료 후 UI 업데이트 (예: 타이틀 라벨, 메시지 라벨, 완료 버튼 등의 애니메이션 효과 적용)
        titleLabel.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
        messageLabel.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        doneButton.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn, .allowUserInteraction]) {
            self.titleLabel.transform = .identity
            self.messageLabel.transform = .identity
            self.doneButton.transform = .identity
        }
    }
    
    private func setupProperty() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(lottieAnimationView)
        view.addSubview(doneButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            lottieAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lottieAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lottieAnimationView.widthAnchor.constraint(equalToConstant: 300),
            lottieAnimationView.heightAnchor.constraint(equalToConstant: 300),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    
    @objc public func doneButtonTapped() {
        isAutoCloseEnabled = false
        delegate?.userRegistDidFinish(success: true, error: nil)
    }
}

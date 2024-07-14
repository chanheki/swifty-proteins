import UIKit

public class PasswordRegistrationFailureView: UIView {
    // 이 클래스에서 사용할 UI 요소들을 정의합니다.
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 등록에 실패했습니다. 다시 시도해주세요."
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.backgroundColor, for: .normal)
        button.backgroundColor = .foregroundColor
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .backgroundColor
        
        addSubview(messageLabel)
        addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            confirmButton.widthAnchor.constraint(equalToConstant: 100),
            confirmButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        confirmButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissView() {
        self.removeFromSuperview()
    }
}

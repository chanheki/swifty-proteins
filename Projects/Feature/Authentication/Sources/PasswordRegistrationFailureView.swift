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
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        
        addSubview(messageLabel)
        addSubview(confirmButton)
        
        // messageLabel의 레이아웃 제약조건 설정
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50)
        ])
        
        // confirmButton의 레이아웃 제약조건 설정
        NSLayoutConstraint.activate([
            confirmButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            confirmButton.widthAnchor.constraint(equalToConstant: 100),
            confirmButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // 확인 버튼 클릭 이벤트 추가
        confirmButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        // 화면 밖 터치 시 뷰 사라지게 하는 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissView() {
        self.removeFromSuperview()
    }
}

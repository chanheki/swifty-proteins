//
//  CustomErrorView.swift
//  SharedCommonUI
//
//  Created by Chan on 7/14/24.
//

import UIKit

public class CustomErrorView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "CustomErrorView"
        label.textColor = .foregroundColor
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
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
    
    private weak var parentViewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public convenience init(errorMessage: String, parentViewController: UIViewController, button: String) {
        self.init(frame: .zero)
        self.messageLabel.text = errorMessage
        self.parentViewController = parentViewController
        
        setupView()
        setupButton()
        
        self.confirmButton.setTitle("\(button)", for: .normal)
    }
    
    public convenience init(errorMessage: String, parentViewController: UIViewController) {
        self.init(frame: .zero)
        self.messageLabel.text = errorMessage
        self.parentViewController = parentViewController
        
        setupModal()
    }
    
    public convenience init(errorMessage: String) {
        self.init(frame: .zero)
        self.messageLabel.text = errorMessage
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        backgroundColor = .backgroundColor
        
        addSubview(messageLabel)
        addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            confirmButton.widthAnchor.constraint(equalToConstant: 100),
            confirmButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupButton() {
        confirmButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    private func setupModal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissView() {
        self.removeFromSuperview()
        parentViewController?.navigationController?.popViewController(animated: true)
    }
}

//
//  SettingsViewController.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/4/24.
//

import UIKit
import Combine

import SharedCommonUI
import DomainAuthentication
import DomainSettings
import FeatureSettingsInterface
import FeatureAuthenticationInterface
import FeatureAuthentication

public final class SettingsViewController: BaseViewController<SettingsView> {
    
    private var viewModel: SettingsViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupProperty()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let settingsView = self.contentView as? SettingsView else {
            return
        }
        
        if let viewModel = viewModel {
            viewModel
                .$settings
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                    guard self != nil else { return }
                    settingsView.settingListTableView.reloadData()
                }
                .store(in: &cancellables)
            
            viewModel.$logoutSuccess
                .sink { [weak self] success in
                    if let success = success {
                        self?.handleLogout(success: success)
                    }
                }
                .store(in: &cancellables)
            
            viewModel.$deleteAccountSuccess
                .sink { [weak self] success in
                    if let success = success {
                        self?.handleDeleteAccount(success: success)
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        self.setNavigationBarHidden(true)
    }
    
    public override func setupProperty() {
        if let settingsListView = self.contentView as? SettingsView {
            viewModel = settingsListView.viewModel
            settingsListView.settingListTableView.selectionDelegate = self
        }
        
        view.backgroundColor = .backgroundColor
        self.title = "Settings"
    }
    
    private func handleLogout(success: Bool) {
        if success {
            NotificationCenter.default.post(name: NSNotification.Name("UserDidLogout"), object: nil)
        } else {
            self.showErrorView(message: "로그아웃에 실패하였습니다. 다시시도 해주세요.")
        }
    }
    
    private func handleDeleteAccount(success: Bool) {
        if success {
            NotificationCenter.default.post(name: NSNotification.Name("UserDidLogout"), object: nil)
        } else {
            self.showErrorView(message: "회원 탈퇴에 실패하였습니다. 다시시도 해주세요.")
        }
    }
    
    func pushPasswordResetView() {
        let resetPasswordViewController = PasswordRegistrationViewController()
        resetPasswordViewController.delegate = self
        navigationController?.pushViewController(resetPasswordViewController, animated: true)
    }
    
    func showLoginSuccessView() {
        let loginSuccessViewController = PasswordRegistrationSuccessViewController()
        loginSuccessViewController.delegate = self
        self.present(loginSuccessViewController, animated: true)
    }
    
    private func showErrorView(message: String) {
        let errorView = CustomErrorView(errorMessage: message, parentViewController: self)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SettingsViewController: PasswordRegistrationViewControllerDelegate, PasswordRegistrationSuccessViewControllerDelegate {
    // PasswordRegistrationViewControllerDelegate
    public func passwordRegistDidFinish(success: Bool, error: Error?) {
        if success {
            print("비밀번호 변경 성공")
            navigationController?.popViewController(animated: true)
            self.showLoginSuccessView()
        } else {
            print("비밀번호 변겅 실패: \(String(describing: error?.localizedDescription))")
        }
    }
    
    // PasswordRegistrationSuccessViewControllerDelegate
    public func userRegistDidFinish(success: Bool, error: Error?) {
        if success {
            print("비밀번호 변경 끝")
            self.dismiss(animated: true, completion: nil)
        } else {
            print("전체 로그인 실패: \(String(describing: error?.localizedDescription))")
        }
    }
}

extension SettingsViewController: SettingsListTableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        let setting = viewModel.settings[indexPath.row]
        
        switch setting {
        case .id:
            viewModel.performAction(for: .id)
            break
            
        case .resetPassword:
            self.pushPasswordResetView()
            
        case .biometric:
            // 생체 인식 설정 로직 (스위치로 처리)
            break
            
        case .logout:
            viewModel.performAction(for: .logout)
            // 로그아웃 후 보여질 view 설정.
            break
        case .deleteAccount:
            // 삭제전 보여질 view 설정
            viewModel.performAction(for: .deleteAccount)
            // 삭제 후 보여질 view 설정
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

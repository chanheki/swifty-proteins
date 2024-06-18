//
//  SettingsViewController.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/4/24.
//

import UIKit
import Combine

import FeatureAuthentication
import FeatureAuthenticationInterface
import FeatureSettingsInterface
import DomainSettings
import SharedCommonUI

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
            // 성공적으로 로그아웃 처리, 예: 로그인 화면으로 전환
        } else {
            // 로그아웃 실패 처리, 예: 에러 메시지 표시
        }
    }

    private func handleDeleteAccount(success: Bool) {
        if success {
            // 성공적으로 회원 탈퇴 처리, 예: 로그인 화면으로 전환
        } else {
            // 회원 탈퇴 실패 처리, 예: 에러 메시지 표시
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

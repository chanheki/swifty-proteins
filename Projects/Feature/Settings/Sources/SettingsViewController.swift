//
//  SettingsViewController.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/4/24.
//

import UIKit
import Combine

import DomainSettings
import SharedCommonUI
import SharedModel

public class SettingsViewController: BaseViewController<SettingsView> {
    
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
                    guard let self = self else { return }
                    settingsView.settingListTableView.reloadData()
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
    
}

extension SettingsViewController: SettingsListTableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        let setting = viewModel.settings[indexPath.row]
        
        switch setting {
        case .id:
            // ID 확인 로직
            break
            
        case .resetPassword:
            // 비밀번호 재설정 뷰 컨트롤러로 이동
            let resetPasswordVC = SettingsViewController()
            navigationController?.pushViewController(resetPasswordVC, animated: true)
            
        case .biometric:
            // 생체 인식 설정 로직 (스위치로 처리)
            break
            
        case .logout:
            viewModel.performAction(for: .logout)
            // 로그아웃 후 보여질 view 설정.
            break
        case .unsubscribe:
            // 삭제전 보여질 view 설정
            viewModel.performAction(for: .unsubscribe)
            // 삭제 후 보여질 view 설정
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

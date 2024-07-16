//
//  SettingsViewModel.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/4/24.
//

import UIKit
import Combine

import CoreCoreDataProvider
import CoreAuthentication
import DomainSettingsInterface

public final class SettingsViewModel {
    
    @Published public var settings: [SettingsType]
    @Published public var logoutSuccess: Bool?
    @Published public var deleteAccountSuccess: Bool?
    
    public init(settings: [SettingsType] = [.id, .resetPassword, .biometric, .logout, .deleteAccount]) {
        self.settings = settings
    }
    
    public func toggleBiometric(_ isOn: Bool) {
        AppStateManager.shared.isBiometricEnabled = isOn
    }
    
    public func performAction(for setting: SettingsType) {
        switch setting {
        case .id:
            print(CoreDataProvider.shared.fetchAllUsers())
            
            // ID 관련 로직 처리
            break
        case .logout:
            GoogleOAuthManager.shared.firebaseSignOut { success, error in
                if success {
                    CoreDataProvider.shared.clearCoreData()
                    self.logoutSuccess = true
                } else {
                    self.logoutSuccess = false
                }
            }
            break
        case .deleteAccount:
            GoogleOAuthManager.shared.firebaseDeleteAccount { success, error in
                if success {
                    CoreDataProvider.shared.clearCoreData()
                    self.deleteAccountSuccess = true
                } else {
                    self.deleteAccountSuccess = false
                }
            }
            break
        case .resetPassword, .biometric:
            break
        }
    }
}

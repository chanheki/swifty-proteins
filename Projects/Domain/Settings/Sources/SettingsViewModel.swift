//
//  SettingsViewModel.swift
//  FeatureAuthentication
//
//  Created by Chan on 6/4/24.
//

import Combine

import DomainSettingsInterface
import CoreAuthentication

public final class SettingsViewModel {
    // Output
    @Published public var settings: [SettingsType]
    
    // 생성자
    public init(settings: [SettingsType] = [.id, .resetPassword, .biometric, .logout, .unsubscribe]) {
        self.settings = settings
    }
    
    // Input
    public func performAction(for setting: SettingsType) {
        switch setting {
        case .id:
            // ID 관련 로직 처리
            break
        case .resetPassword:
            // 비밀번호 재설정 로직 처리
            break
        case .biometric:
            
            break
        case .logout:
            GoogleOAuthManager.shared.firebaseSignOut()
            break
        case .unsubscribe:
            GoogleOAuthManager.shared.firebaseUnsubscribe()
            break
        }
    }
    
    public func toggleBiometric(_ isOn: Bool) {
        // 생체 인식 설정 상태 변경 로직 처리
    }
}

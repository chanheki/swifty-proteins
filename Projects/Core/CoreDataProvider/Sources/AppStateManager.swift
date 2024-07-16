//
//  AppStateManager.swift
//  CoreCoreDataProvider
//
//  Created by Chan on 6/16/24.
//

import UIKit

public final class AppStateManager {
    public static let shared = AppStateManager()
    public init() {
        defaults.register(defaults: [
            "isPossibleCoverView": false,
            "isLoggedIn": false
        ])
    }
    
    private let defaults = UserDefaults.standard
    
    public var isLoggedIn: Bool {
        get { defaults.bool(forKey: "isLoggedIn") }
        set { defaults.set(newValue, forKey: "isLoggedIn") }
    }
    
    public var userID: String? {
        get { defaults.string(forKey: "userID") }
        set { defaults.set(newValue, forKey: "userID") }
    }
    
    public var userName: String? {
        get { defaults.string(forKey: "userName") }
        set { defaults.set(newValue, forKey: "userName") }
    }
    
    public var isBiometricEnabled: Bool {
        get { defaults.bool(forKey: "isBiometricEnabled") }
        set { defaults.set(newValue, forKey: "isBiometricEnabled") }
    }
    
    public var isPossibleCoverView: Bool {
        get { defaults.bool(forKey: "isPossibleCoverView") }
        set { defaults.set(newValue, forKey: "isPossibleCoverView") }
    }
    
    public var isShowPasswordPrompt: Bool = false
    public var isBegin: Bool = true
    
}

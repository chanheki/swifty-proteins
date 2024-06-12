//
//  Modules.swift
//  DependencyPlugin
//
//  Created by 김찬희 on 2024/03/31.
//

import Foundation
import ProjectDescription

public enum ModulePath {
    case feature(Feature)
    case domain(Domain)
    case core(Core)
    case shared(Shared)
}

// MARK: AppModule

public extension ModulePath {
    enum App: String, CaseIterable {
        case IOS
        
        public static let name: String = "App"
    }
}


// MARK: FeatureModule
public extension ModulePath {
    enum Feature: String, CaseIterable {
        case Settings
        case Authentication
        case Proteins

        public static let name: String = "Feature"
    }
}

// MARK: DomainModule

public extension ModulePath {
    enum Domain: String, CaseIterable {
        case Settings
        case Authentication
        case Biometric
        case Proteins

        public static let name: String = "Domain"
    }
}

// MARK: CoreModule

public extension ModulePath {
    enum Core: String, CaseIterable {
        case CoreDataProvider
        case Authentication
        case Network

        public static let name: String = "Core"
    }
}

// MARK: SharedModule

public extension ModulePath {
    enum Shared: String, CaseIterable {
        case CommonUI
        case Extensions
        case DesignSystem

        public static let name: String = "Shared"
    }
}

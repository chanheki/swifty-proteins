//
//  Environment.swift
//  DependencyPlugin
//
//  Created by 김찬희 on 2024/03/31.
//

import Foundation
import ProjectDescription

public extension Project {
    enum Environment {
        public static let appName = "SwiftyProteins"
        public static let deploymentTarget = DeploymentTargets.iOS("15.0")
        public static let bundlePrefix = "kr.mois.SwiftyProteins"
    }
}

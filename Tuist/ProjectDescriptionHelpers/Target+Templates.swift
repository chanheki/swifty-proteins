//
//  Target+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 김찬희 on 2024/03/31.
//

import ProjectDescription
import DependencyPlugin

// MARK: Target + Template

public struct TargetFactory {
    var name: String
    var destinations: Destinations
    var product: Product
    var productName: String?
    var bundleId: String?
    var deploymentTargets: DeploymentTargets?
    var infoPlist: InfoPlist?
    var sources: SourceFilesList?
    var resources: ResourceFileElements?
    var copyFiles: [CopyFilesAction]?
    var headers: Headers?
    var entitlements: Entitlements?
    var scripts: [TargetScript]
    var dependencies: [TargetDependency]
    var settings: Settings?
    var coreDataModels: [CoreDataModel]
    var environmentVariables: [String: EnvironmentVariable]
    var launchArguments: [LaunchArgument]
    var additionalFiles: [FileElement]
    var buildRules: [BuildRule]
    var mergedBinaryType: MergedBinaryType
    var mergeable: Bool
    
    public init(
        name: String = "",
        destinations: Destinations = .iOS,
        product: Product = .staticLibrary,
        productName: String? = nil,
        bundleId: String? = nil,
        deploymentTargets: DeploymentTargets? = nil,
        infoPlist: InfoPlist? = nil,
        sources: SourceFilesList? = .sources,
        resources: ResourceFileElements? = nil,
        copyFiles: [CopyFilesAction]? = nil,
        headers: Headers? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings? = Settings.settings(
            base: [
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES"
            ],
            configurations: [
                .debug(name: "Debug", xcconfig: .relativeToRoot("Configs/Debug.xcconfig")),
                .release(name: "Release", xcconfig: .relativeToRoot("Configs/Release.xcconfig"))
            ],
            defaultSettings: .recommended
        ),
        coreDataModels: [CoreDataModel] = [],
        environmentVariables: [String: EnvironmentVariable] = [:],
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = [],
        buildRules: [BuildRule] = [],
        mergedBinaryType: MergedBinaryType = .disabled,
        mergeable: Bool = false
    ) {
        self.name = name
        self.destinations = destinations
        self.product = product
        self.productName = productName
        self.bundleId = bundleId
        self.deploymentTargets = Project.Environment.deploymentTarget
        self.infoPlist = infoPlist
        self.sources = sources
        self.resources = resources
        self.copyFiles = copyFiles
        self.headers = headers
        self.entitlements = entitlements
        self.scripts = scripts
        self.dependencies = dependencies
        self.settings = settings
        self.coreDataModels = coreDataModels
        self.environmentVariables = environmentVariables
        self.launchArguments = launchArguments
        self.additionalFiles = additionalFiles
        self.buildRules = buildRules
        self.mergedBinaryType = mergedBinaryType
        self.mergeable = mergeable
    }
}


public extension Target {
    static func make(factory: TargetFactory) -> Self {
        return .target(
            name: factory.name,
            destinations: factory.destinations,
            product: factory.product,
            productName: factory.productName,
            bundleId: factory.bundleId ?? Project.Environment.bundlePrefix + ".\(factory.name)",
            deploymentTargets: factory.deploymentTargets,
            infoPlist: factory.infoPlist ?? .default,
            sources: factory.sources,
            resources: factory.resources,
            copyFiles: factory.copyFiles,
            headers: factory.headers,
            entitlements: factory.entitlements,
            scripts: factory.scripts,
            dependencies: factory.dependencies,
            settings: factory.settings,
            coreDataModels: factory.coreDataModels,
            environmentVariables: factory.environmentVariables,
            launchArguments: factory.launchArguments,
            additionalFiles: factory.additionalFiles,
            buildRules: factory.buildRules,
            mergedBinaryType: factory.mergedBinaryType,
            mergeable: factory.mergeable
        )
    }
}

// MARK: Target + App

public extension Target {
    static func app(implements module: ModulePath.App, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.App.name + module.rawValue
        
        switch module {
        case .IOS:
            newFactory.destinations = .iOS
            newFactory.product = .app
            newFactory.name = Project.Environment.appName
            newFactory.bundleId = Project.Environment.bundlePrefix
            newFactory.resources = ["Resources/**"]
            newFactory.entitlements = "Resources/SwiftyProteins.entitlements"
            newFactory.productName = "SwiftyProteins"
            return make(factory: newFactory)
        }
    }
}


// MARK: Target + Feature

public extension Target {
    static func feature(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name
        
        return make(factory: newFactory)
    }
    
    static func feature(implements module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue
        
        return make(factory: newFactory)
    }
    
    static func feature(tests module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue + "Tests"
        newFactory.sources = .tests
        newFactory.product = .unitTests
        
        return make(factory: newFactory)
    }
    
    static func feature(testing module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue + "Testing"
        newFactory.sources = .testing
        
        return make(factory: newFactory)
    }
    
    static func feature(interface module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue + "Interface"
        newFactory.sources = .interface
        
        return make(factory: newFactory)
    }
    
    static func feature(example module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue + "Example"
        newFactory.sources = .exampleSources
        newFactory.product = .app
        
        return make(factory: newFactory)
    }
}

// MARK: Target + Domain

public extension Target {
    static func domain(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name
        
        return make(factory: newFactory)
    }
    
    static func domain(implements module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue
        
        return make(factory: newFactory)
    }
    
    static func domain(tests module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue + "Tests"
        newFactory.product = .unitTests
        newFactory.sources = .tests
        
        return make(factory: newFactory)
    }
    
    static func domain(testing module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue + "Testing"
        newFactory.sources = .testing
        
        return make(factory: newFactory)
    }
    
    static func domain(interface module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue + "Interface"
        newFactory.sources = .interface
        
        return make(factory: newFactory)
    }
}

// MARK: Target + Core

public extension Target {
    static func core(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name
        
        return make(factory: newFactory)
    }
    
    static func core(implements module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue
        
        return make(factory: newFactory)
    }
    
    static func core(tests module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue + "Tests"
        newFactory.product = .unitTests
        newFactory.sources = .tests
        
        return make(factory: newFactory)
    }
    
    static func core(testing module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue + "Testing"
        newFactory.sources = .testing
        
        return make(factory: newFactory)
    }
    
    static func core(interface module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue + "Interface"
        newFactory.sources = .interface
        
        return make(factory: newFactory)
    }
}

// MARK: Target + Shared

public extension Target {
    static func shared(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Shared.name
        
        return make(factory: newFactory)
    }
    
    static func shared(implements module: ModulePath.Shared, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Shared.name + module.rawValue
        
        if module == .DesignSystem {
            newFactory.sources = .sources
            newFactory.resources = ["Resources/**"]
            newFactory.product = .staticFramework
        }
        
        return make(factory: newFactory)
    }
    
    static func shared(tests module: ModulePath.Shared, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Shared.name + module.rawValue + "Tests"
        newFactory.product = .unitTests
        newFactory.sources = .tests
        
        return make(factory: newFactory)
    }
    
    static func shared(testing module: ModulePath.Shared, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Shared.name + module.rawValue + "Testing"
        newFactory.sources = .testing
        
        return make(factory: newFactory)
    }
    
    static func shared(interface module: ModulePath.Shared, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Shared.name + module.rawValue + "Interface"
        newFactory.sources = .interface
        
        return make(factory: newFactory)
    }
}

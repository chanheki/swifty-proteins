import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Core.name+ModulePath.Core.Authentication.rawValue,
    targets: [
        .core(
            interface: .Authentication,
            factory: .init(
                dependencies: [
                    .shared
                ]
            )
        ),
        .core(
            implements: .Authentication,
            factory: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .core(interface: .Authentication),
                    .core(interface: .CoreDataProvider),
                    .external(name: "FirebaseAppCheck"),
                    .external(name: "FirebaseAppDistribution-Beta"),
                    .external(name: "FirebaseAnalytics"),
                    .external(name: "FirebaseAuthCombine-Community"),
                    .external(name: "FirebaseFirestoreCombine-Community"),
                    .external(name: "Alamofire"),
                    .external(name: "GoogleSignIn"),
                    .external(name: "GoogleSignInSwift"),
                ]
            )
        ),
        .core(
            testing: .Authentication,
            factory: .init(
                dependencies: [
                    .core(interface: .Authentication)
                ]
            )
        ),
        .core(
            tests: .Authentication,
            factory: .init(
                dependencies: [
                    .core(testing: .Authentication)
                ]
            )
        ),
        
    ]
)

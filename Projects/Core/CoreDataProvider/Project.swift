import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Core.name+ModulePath.Core.CoreDataProvider.rawValue,
    targets: [    
        .core(
            interface: .CoreDataProvider,
            factory: .init(
                dependencies: [
                    .shared
                ]
            )
        ),
        .core(
            implements: .CoreDataProvider,
            factory: .init(
                resources: ["Resources/**"],
                dependencies: [
                    .core(interface: .CoreDataProvider)
                ]
            )
        ),
        .core(
            testing: .CoreDataProvider,
            factory: .init(
                dependencies: [
                    .core(interface: .CoreDataProvider)
                ]
            )
        ),
        .core(
            tests: .CoreDataProvider,
            factory: .init(
                dependencies: [
                    .core(testing: .CoreDataProvider)
                ]
            )
        ),

    ]
)

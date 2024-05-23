import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Shared.name+ModulePath.Shared.CommonUI.rawValue,
    targets: [    
        .shared(
            interface: .CommonUI,
            factory: .init()
        ),
        .shared(
            implements: .CommonUI,
            factory: .init(
                dependencies: [
                    .shared(interface: .CommonUI)
                ]
            )
        ),
        .shared(
            testing: .CommonUI,
            factory: .init(
                dependencies: [
                    .shared(interface: .CommonUI)
                ]
            )
        ),
        .shared(
            tests: .CommonUI,
            factory: .init(
                dependencies: [
                    .shared(testing: .CommonUI)
                ]
            )
        ),

    ]
)

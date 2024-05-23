import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Core.name+ModulePath.Core.Authentication.rawValue,
    targets: [    
        .core(
            interface: .Authentication,
            factory: .init()
        ),
        .core(
            implements: .Authentication,
            factory: .init(
                dependencies: [
                    .core(interface: .Authentication)
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

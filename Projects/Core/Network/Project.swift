import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Core.name+ModulePath.Core.Network.rawValue,
    targets: [    
        .core(
            interface: .Network,
            factory: .init()
        ),
        .core(
            implements: .Network,
            factory: .init(
                dependencies: [
                    .core(interface: .Network),
                    .external(name: "AlamofireDynamic")
                ]
            )
        ),
    
        .core(
            testing: .Network,
            factory: .init(
                dependencies: [
                    .core(interface: .Network)
                ]
            )
        ),
        .core(
            tests: .Network,
            factory: .init(
                dependencies: [
                    .core(testing: .Network)
                ]
            )
        ),

    ]
)

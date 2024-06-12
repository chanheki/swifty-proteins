import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Shared.name+ModulePath.Shared.Extensions.rawValue,
    targets: [    
        .shared(
            interface: .Extensions,
            factory: .init()
        ),
        .shared(
            implements: .Extensions,
            factory: .init(
                dependencies: [
                    .shared(interface: .Extensions)
                ]
            )
        ),

    ]
)

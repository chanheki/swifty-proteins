import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Shared.name+ModulePath.Shared.Model.rawValue,
    targets: [    
        .shared(
            interface: .Model,
            factory: .init()
        ),
        .shared(
            implements: .Model,
            factory: .init(
                dependencies: [
                    .shared(interface: .Model)
                ]
            )
        ),
    
        .shared(
            testing: .Model,
            factory: .init(
                dependencies: [
                    .shared(interface: .Model)
                ]
            )
        ),
        .shared(
            tests: .Model,
            factory: .init(
                dependencies: [
                    .shared(testing: .Model)
                ]
            )
        ),

    ]
)

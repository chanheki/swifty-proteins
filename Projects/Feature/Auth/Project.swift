import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name+ModulePath.Feature.Auth.rawValue,
    targets: [    
        .feature(
            interface: .Auth,
            factory: .init()
        ),
        .feature(
            implements: .Auth,
            factory: .init(
                dependencies: [
                    .feature(interface: .Auth)
                ]
            )
        ),
    
        .feature(
            testing: .Auth,
            factory: .init(
                dependencies: [
                    .feature(interface: .Auth)
                ]
            )
        ),
        .feature(
            tests: .Auth,
            factory: .init(
                dependencies: [
                    .feature(testing: .Auth)
                ]
            )
        ),
    
        .feature(
            example: .Auth,
            factory: .init(
                dependencies: [
                    .feature(interface: .Auth)
                ]
            )
        )

    ]
)

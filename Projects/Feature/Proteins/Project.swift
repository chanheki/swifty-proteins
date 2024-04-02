import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name+ModulePath.Feature.Proteins.rawValue,
    targets: [    
        .feature(
            interface: .Proteins,
            factory: .init(
                dependencies: [
                    .domain
                ]
            )
        ),
        .feature(
            implements: .Proteins,
            factory: .init(
                dependencies: [
                    .feature(interface: .Proteins),
                ]
            )
        ),
    
        .feature(
            testing: .Proteins,
            factory: .init(
                dependencies: [
                    .feature(interface: .Proteins)
                ]
            )
        ),
        .feature(
            tests: .Proteins,
            factory: .init(
                dependencies: [
                    .feature(testing: .Proteins)
                ]
            )
        ),
    
        .feature(
            example: .Proteins,
            factory: .init(
                dependencies: [
                    .feature(interface: .Proteins)
                ]
            )
        )

    ]
)

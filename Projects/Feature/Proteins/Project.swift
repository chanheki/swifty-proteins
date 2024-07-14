import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name+ModulePath.Feature.Proteins.rawValue,
    targets: [    
        .feature(
            implements: .Proteins,
            factory: .init(
                dependencies: [
                    .feature(interface: .Proteins),
                    .feature(testing: .Proteins),
                    .feature(interface: .Authentication),
                    .feature(interface: .Settings),
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
                    .feature(implements: .Proteins)
                ]
            )
        ),
        .feature(
            interface: .Proteins,
            factory: .init(
                dependencies: [
                    .domain
                ]
            )
        ),
    ]
)

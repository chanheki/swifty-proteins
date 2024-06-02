import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.Proteins.rawValue,
    targets: [    
        .domain(
            interface: .Proteins,
            factory: .init(
                dependencies: [
                    .core
                ]
            )
        ),
        .domain(
            implements: .Proteins,
            factory: .init(
                dependencies: [
                    .domain(interface: .Proteins)
                ]
            )
        ),
        .domain(
            testing: .Proteins,
            factory: .init(
                dependencies: [
                    .domain(interface: .Proteins)
                ]
            )
        ),
        .domain(
            tests: .Proteins,
            factory: .init(
                dependencies: [
                    .domain(implements: .Proteins),
                    .domain(testing: .Proteins)
                ]
            )
        ),

    ]
)

import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.Settings.rawValue,
    targets: [    
        .domain(
            implements: .Settings,
            factory: .init(
                dependencies: [
                    .domain(interface: .Settings),
                ]
            )
        ),
        .domain(
            testing: .Settings,
            factory: .init(
                dependencies: [
                    .domain(interface: .Settings)
                ]
            )
        ),
        .domain(
            tests: .Settings,
            factory: .init(
                dependencies: [
                    .domain(testing: .Settings)
                ]
            )
        ),
        .domain(
            interface: .Settings,
            factory: .init(
                dependencies: [
                    .core
                ]
            )
        ),
    ]
)

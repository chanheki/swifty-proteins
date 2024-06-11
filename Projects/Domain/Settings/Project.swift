import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.Settings.rawValue,
    targets: [    
        .domain(
            interface: .Settings,
            factory: .init(
                dependencies: [
                    .core
                ]
            )
        ),
        .domain(
            implements: .Settings,
            factory: .init(
                dependencies: [
                    .domain(interface: .Settings)
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

    ]
)

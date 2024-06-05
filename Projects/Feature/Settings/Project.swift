import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name+ModulePath.Feature.Settings.rawValue,
    targets: [    
        .feature(
            interface: .Settings,
            factory: .init(
                dependencies: [
                    .domain
                ]
            )
        ),
        .feature(
            implements: .Settings,
            factory: .init(
                dependencies: [
                    .feature(interface: .Settings)
                ]
            )
        ),
        .feature(
            testing: .Settings,
            factory: .init(
                dependencies: [
                    .feature(interface: .Settings)
                ]
            )
        ),
        .feature(
            tests: .Settings,
            factory: .init(
                dependencies: [
                    .feature(testing: .Settings)
                ]
            )
        ),

    ]
)

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name+ModulePath.Feature.Authentication.rawValue,
    targets: [    
        .feature(
            interface: .Authentication,
            factory: .init(
                dependencies: [
                    .domain
                ]
            )
        ),
        .feature(
            implements: .Authentication,
            factory: .init(
                dependencies: [
                    .feature(interface: .Authentication)
                ]
            )
        ),
    
        .feature(
            testing: .Authentication,
            factory: .init(
                dependencies: [
                    .feature(interface: .Authentication)
                ]
            )
        ),
        .feature(
            tests: .Authentication,
            factory: .init(
                dependencies: [
                    .feature(testing: .Authentication)
                ]
            )
        )
    ]
)

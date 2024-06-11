import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.Authentication.rawValue,
    targets: [    
        .domain(
            interface: .Authentication,
            factory: .init(
                dependencies: [
                    .core
                ]
            )
        ),
        .domain(
            implements: .Authentication,
            factory: .init(
                dependencies: [
                    .core(implements: .CoreDataProvider),
                    .domain(interface: .Authentication)
                ]
            )
        ),
        .domain(
            testing: .Authentication,
            factory: .init(
                dependencies: [
                    .domain(interface: .Authentication)
                ]
            )
        ),
        .domain(
            tests: .Authentication,
            factory: .init(
                dependencies: [
                    .domain(testing: .Authentication)
                ]
            )
        ),

    ]
)

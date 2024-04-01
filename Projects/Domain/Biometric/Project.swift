import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.Biometric.rawValue,
    targets: [    
        .domain(
            interface: .Biometric,
            factory: .init(
                dependencies: [
                    .core
                ]
            )
        ),
        .domain(
            implements: .Biometric,
            factory: .init(
                dependencies: [
                    .domain(interface: .Biometric)
                ]
            )
        ),
    
        .domain(
            testing: .Biometric,
            factory: .init(
                dependencies: [
                    .domain(interface: .Biometric)
                ]
            )
        ),
        .domain(
            tests: .Biometric,
            factory: .init(
                dependencies: [
                    .domain(testing: .Biometric)
                ]
            )
        ),

    ]
)

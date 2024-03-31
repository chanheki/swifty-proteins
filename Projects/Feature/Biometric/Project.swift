import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name+ModulePath.Feature.Biometric.rawValue,
    targets: [    
        .feature(
            interface: .Biometric,
            factory: .init()
        ),
        .feature(
            implements: .Biometric,
            factory: .init(
                dependencies: [
                    .feature(interface: .Biometric)
                ]
            )
        ),
    
        .feature(
            testing: .Biometric,
            factory: .init(
                dependencies: [
                    .feature(interface: .Biometric)
                ]
            )
        ),
        .feature(
            tests: .Biometric,
            factory: .init(
                dependencies: [
                    .feature(testing: .Biometric)
                ]
            )
        ),
    
        .feature(
            example: .Biometric,
            factory: .init(
                dependencies: [
                    .feature(interface: .Biometric)
                ]
            )
        )

    ]
)

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
                    // TODO: 화면 전환을 상위로 위임하면 제거 (현재 구체 VC를 직접 생성함)
                    .feature(implements: .Authentication),
                    .feature(implements: .Settings),
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

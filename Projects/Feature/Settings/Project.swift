import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name+ModulePath.Feature.Settings.rawValue,
    targets: [    
        .feature(
            implements: .Settings,
            factory: .init(
                dependencies: [
                    .feature(interface: .Settings),
                    .feature(interface: .Authentication),
                    // TODO: 화면 전환을 상위로 위임하면 제거 (현재 구체 VC를 직접 생성함)
                    .feature(implements: .Authentication),
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
        .feature(
            interface: .Settings,
            factory: .init(
                dependencies: [
                    .domain
                ]
            )
        ),
    ]
)

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .feature(
        factory: .init(
            dependencies: [
                .feature(implements: .Biometric),
                .feature(implements: .Proteins),
                .domain,
                // make module을 통해 생성한 모듈을 각 레이어의 최상위부분에서 디펜던시를 주입시켜야함
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Feature",
    targets: targets
)

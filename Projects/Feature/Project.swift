import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .feature(
        factory: .init(
            dependencies: [
                .feature(implements: .Auth),
                .feature(implements: .Proteins),
                .domain
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Feature",
    targets: targets
)

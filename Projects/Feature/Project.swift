import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .feature(
        factory: .init(
            dependencies: [
                .feature(implements: .Authentication),
                .feature(implements: .Proteins),
                .feature(implements: .Settings),
                .domain,
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Feature",
    targets: targets
)

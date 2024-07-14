import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .feature(
        factory: .init(
            dependencies: [
                .domain,
                .feature(implements: .Authentication),
                .feature(implements: .Proteins),
                .feature(implements: .Settings),
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Feature",
    targets: targets
)

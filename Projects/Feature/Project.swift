import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .feature(
        factory: .init(
            dependencies: [
                .domain,
                .feature(implements: .Authentication),
                .feature(implements: .Proteins)
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Feature",
    targets: targets
)

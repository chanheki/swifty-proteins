import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let targets: [Target] = [
    .domain(
        factory: .init(
            dependencies: [
                .domain(implements: .Authentication),
                .domain(implements: .Biometric),
                .domain(implements: .Proteins),
                .domain(implements: .Settings),
                .core,
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Domain",
    targets: targets
)

import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let targets: [Target] = [
    .core(
        factory: .init(
            dependencies: [
                .core(implements: .Network),
                .shared
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Core",
    targets: targets
)

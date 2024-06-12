import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let targets: [Target] = [
    .shared(
        factory: .init(
            dependencies: [
                .shared(implements: .CommonUI),
                .shared(implements: .Extensions),
                .shared(implements: .DesignSystem)
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Shared",
    targets: targets
)

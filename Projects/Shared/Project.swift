import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let targets: [Target] = [
    .shared(
        factory: .init(
            dependencies: [
                .shared(implements: .DesignSystem),
                .shared(implements: .Extensions),
                .shared(implements: .Model),
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Shared",
    targets: targets
)

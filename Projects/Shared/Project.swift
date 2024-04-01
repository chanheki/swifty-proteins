import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let targets: [Target] = [
    .shared(
        factory: .init(
            dependencies: [
                .shared(implements: .DesignSystem),
                .shared(implements: .Extensions)
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Shared",
    targets: targets
)

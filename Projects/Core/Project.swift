import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let targets: [Target] = [
    .core(
        factory: .init(
            dependencies: [
                .shared,
                .core(implements: .Authentication),
                .core(implements: .CoreDataProvider),
                .core(implements: .Network),
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Core",
    targets: targets
)

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .shared(
        implements: .DesignSystem,
        factory: .init(
                dependencies: [
                    .external(name: "Lottie")
                ]
            )
    )
]

let project: Project = .init(
    name: "SharedDesignSystem",
    targets: targets,
    resourceSynthesizers: [
        .assets(),
        .fonts()
    ]
)

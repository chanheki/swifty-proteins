import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .shared(
        implements: .DesignSystem,
        factory: .init()
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

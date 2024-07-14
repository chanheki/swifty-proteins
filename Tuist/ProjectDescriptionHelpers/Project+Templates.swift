import ProjectDescription

public extension Project {
    static func makeModule(name: String, targets: [Target]) -> Self {
        let name: String = name
        let organizationName: String? = nil
        let options: Project.Options = .options()
        let packages: [Package] = []
        let settings: Settings? = Settings.settings(
            base: [
                "DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)",
                "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"
            ],
            configurations: [
                .debug(name: .debug, settings: [:], xcconfig: nil),
                .release(name: .release, settings: [:], xcconfig: nil)
            ],
            defaultSettings: .recommended
        )
        let targets: [Target] = targets
        let schemes: [Scheme] = []
        let fileHeaderTemplate: FileHeaderTemplate? = nil
        let additionalFiles: [FileElement] = []
        let resourceSynthesizers: [ResourceSynthesizer] = []
        
        return .init(
            name: name,
            organizationName: organizationName,
            options: options,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes,
            fileHeaderTemplate: fileHeaderTemplate,
            additionalFiles: additionalFiles,
            resourceSynthesizers: resourceSynthesizers
        )
    }
}

//
//  Config.swift
//  Packages
//
//  Created by Chan on 3/29/24.
//

import ProjectDescription

let config = Config(
    compatibleXcodeVersions: ["15.2"],
    swiftVersion: "5.9.2",
    plugins: [
            .local(path: .relativeToRoot("Plugins/DependencyPlugin/")),
        ],
    generationOptions: .options()
)

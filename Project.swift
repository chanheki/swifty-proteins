import ProjectDescription

let project = Project(
    name: "SwiftyProteins",
    targets: [
        .target(
            name: "SwiftyProteins",
            destinations: .iOS,
            product: .app,
            bundleId: "kr.mois.SwiftyProteins",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                ]
            ),
            sources: ["SwiftyProteins/Sources/**"],
            resources: ["SwiftyProteins/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "SwiftyProteinsTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "kr.mois.SwiftyProteinsTests",
            infoPlist: .default,
            sources: ["SwiftyProteins/Tests/**"],
            resources: [],
            dependencies: [.target(name: "SwiftyProteins")]
        ),
    ]
)

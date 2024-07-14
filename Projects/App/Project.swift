import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let targets: [Target] = [
    .app(
        implements: .IOS,
        factory: .init(
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
                    "NSFaceIDUsageDescription": "We need access to Face ID for authentication.",
                    "CFBundleURLTypes": [
                        [
                            "CFBundleTypeRole": "Editor",
                            "CFBundleURLSchemes": ["$(GOOGLE_CLIENT_ID)"]
                        ]
                    ],
                    "BASE_URL": "$(BASE_URL)",
                    "UIBackgroundModes": ["fetch", "processing"],
                    "NSCameraUsageDescription": "We need access to the camera for taking photos.",
                    "NSPhotoLibraryUsageDescription": "We need access to your photo library to select and share photos."
                ]
            ),
            dependencies: [
                .feature
            ]
        )
    ),
]

let project: Project = .makeModule(
    name: "SwiftyProteins",
    targets: targets
)

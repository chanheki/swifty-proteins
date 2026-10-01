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
            ],
            settings: .settings(
                base: [
                    "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                    // Firebase/GoogleUtilities는 static으로 링크되므로 ObjC category를 강제로 로드해야 한다.
                    "OTHER_LDFLAGS": ["$(inherited)", "-ObjC"]
                ],
                configurations: [
                    .debug(name: "Debug", xcconfig: .relativeToRoot("Configs/Debug.xcconfig")),
                    .release(name: "Release", xcconfig: .relativeToRoot("Configs/Release.xcconfig"))
                ],
                defaultSettings: .recommended
            )
        )
    ),
]

let project: Project = .makeModule(
    name: "SwiftyProteins",
    targets: targets
)

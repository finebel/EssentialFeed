import ProjectDescription

let project = Project(
    name: "EssentialAppNew",
    options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    targets: [
        .target(
            name: "EssentialApp",
            destinations: [.iPhone],
            product: .app,
            bundleId: "de.finnebeling.EssentialApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen", // crucial to show app with correct size on screen
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ]
                ]
            ),
            sources: ["EssentialApp/**"],
            resources: [
                "EssentialApp/**/*.storyboard",
                "EssentialApp/**/*.xcassets"
            ],
            dependencies: [
                .project(
                    target: "EssentialFeed",
                    path: .path("../EssentialFeedNew")
                ),
                .project(
                    target: "EssentialFeediOS",
                    path: .path("../EssentialFeedNew")
                )
            ]
        ),
        .target(
            name: "EssentialAppTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "de.finnebeling.essentialAppTests.EssentialAppTests",
            sources: ["EssentialAppTests/**"],
            dependencies: [.target(name: "EssentialApp")]
        )
    ]
)

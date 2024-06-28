import ProjectDescription

let essentialFeedSettings: Settings = .settings(
    configurations: [
        .debug(name: "Debug", xcconfig: .path("../ConfigFiles/EssentialFeed.xcconfig")),
        .release(name: "Release", xcconfig: .path("../ConfigFiles/EssentialFeed.xcconfig"))
    ]
)

let essentialFeediOSSettings: Settings = .settings(
    configurations: [
        .debug(name: "Debug", xcconfig: .path("../ConfigFiles/EssentialFeediOS.xcconfig")),
        .release(name: "Release", xcconfig: .path("../ConfigFiles/EssentialFeediOS.xcconfig"))
    ]
)

let project = Project(
    name: "EssentialFeed",
    options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    targets: [
        .target(
            name: "EssentialFeed",
            destinations: [.iPhone, .mac],
            product: .framework,
            bundleId: "de.finnebeling.EssentialFeed",
            sources: ["EssentialFeed/**"],
            resources: ["EssentialFeed/**/*.strings"],
            settings: essentialFeedSettings,
            coreDataModels: [
                .coreDataModel(
                    .path(
                        "EssentialFeed/FeedCache/Infrastructure/CoreData/FeedStore.xcdatamodeld"
                    )
                )
            ]
        ),
        .target(
            name: "EssentialFeedTests",
            destinations: [.iPhone, .mac],
            product: .unitTests,
            bundleId: "de.finnebeling.EssentialFeedTests",
            sources: ["EssentialFeedTests/**", "EssentialFeedSharedTestHelpers/**"],
            dependencies: [.target(name: "EssentialFeed")]
        ),
        .target(
            name: "EssentialFeedAPIEndToEndTests",
            destinations: [.iPhone, .mac],
            product: .unitTests,
            bundleId: "de.finnebeling.EssentialFeedAPIEndToEndTests",
            sources: ["EssentialFeedAPIEndToEndTests/**", "EssentialFeedSharedTestHelpers/**"],
            dependencies: [.target(name: "EssentialFeed")]
        ),
        .target(
            name: "EssentialFeedCacheIntegrationTests",
            destinations: [.iPhone, .mac],
            product: .unitTests,
            bundleId: "de.finnebeling.EssentialFeedCacheIntegrationTests",
            sources: ["EssentialFeedCacheIntegrationTests/**", "EssentialFeedSharedTestHelpers/**"],
            dependencies: [.target(name: "EssentialFeed")]
        ),
        .target(
            name: "EssentialFeediOS",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "de.finnebeling.EssentialFeed.EssentialFeediOS",
            sources: ["EssentialFeediOS/**"],
            resources: [
                "EssentialFeediOS/**/*.storyboard",
                "EssentialFeediOS/**/*.xcassets"
            ],
            dependencies: [.target(name: "EssentialFeed")],
            settings: essentialFeediOSSettings
        ),
        .target(
            name: "EssentialFeediOSTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "de.finnebeling.EssentialFeed.EssentialFeediOSTests",
            sources: ["EssentialFeediOSTests/**", "EssentialFeedSharedTestHelpers/**"],
            dependencies: [.target(name: "EssentialFeediOS")]
        )
    ]
)

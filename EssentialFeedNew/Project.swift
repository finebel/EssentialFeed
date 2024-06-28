import ProjectDescription

let project = Project(
    name: "EssentialFeedNew",
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
            resources: ["EssentialFeed/Resources/**"],
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
        )
    ]
)

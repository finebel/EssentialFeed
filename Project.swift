import ProjectDescription

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
            sources: ["Sources/EssentialFeed/**"],
            resources: ["Resources/EssentialFeed/**"],
            coreDataModels: [
                .coreDataModel(
                    .path(
                        "Sources/EssentialFeed/FeedCache/Infrastructure/CoreData/FeedStore.xcdatamodeld"
                    )
                )
            ]
        ),
        .target(
            name: "EssentialFeedTests",
            destinations: [.iPhone, .mac],
            product: .unitTests,
            bundleId: "de.finnebeling.EssentialFeedTests",
            sources: ["Sources/EssentialFeedTests/**", "Sources/SharedTestHelpers/**"],
            dependencies: [.target(name: "EssentialFeed")]
        ),
        .target(
            name: "EssentialFeedAPIEndToEndTests",
            destinations: [.iPhone, .mac],
            product: .unitTests,
            bundleId: "de.finnebeling.EssentialFeedAPIEndToEndTests",
            sources: ["Sources/EssentialFeedAPIEndToEndTests/**", "Sources/SharedTestHelpers/**"],
            dependencies: [.target(name: "EssentialFeed")]
        )
    ]
)

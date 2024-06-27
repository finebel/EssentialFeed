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
            sources: ["Sources/EssentialFeedTests/**"],
            dependencies: [.target(name: "EssentialFeed")]
        )
    ]
)

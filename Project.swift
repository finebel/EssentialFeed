import ProjectDescription

let project = Project(
    name: "EssentialFeed",
    targets: [
        .target(
            name: "EssentialFeed",
            destinations: [.iPhone, .mac],
            product: .framework,
            bundleId: "de.finnebeling.EssentialFeed",
            sources: ["Sources/EssentialFeed/**"]
        )
    ]
)

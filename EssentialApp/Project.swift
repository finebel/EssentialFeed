import ProjectDescription

let essentialAppSettings: Settings = .settings(
    configurations: [
        .debug(name: "Debug", xcconfig: .path("../ConfigFiles/EssentialApp.xcconfig")),
        .release(name: "Release", xcconfig: .path("../ConfigFiles/EssentialApp.xcconfig"))
    ]
)

let project = Project(
    name: "EssentialApp",
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
            infoPlist: .file(path: .path("EssentialApp/Info.plist")),
            sources: ["EssentialApp/**"],
            resources: [
                "EssentialApp/**/*.storyboard",
                "EssentialApp/**/*.xcassets"
            ],
            dependencies: [
                .project(
                    target: "EssentialFeed",
                    path: .path("../EssentialFeed")
                ),
                .project(
                    target: "EssentialFeediOS",
                    path: .path("../EssentialFeed")
                )
            ],
            settings: essentialAppSettings
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

import ProjectDescription


// MARK: - EssentialApp

public extension Configuration {
    static var essentialAppDebug: Self {
        .debug(
            name: "Debug",
            settings: SettingsDictionary().automaticCodeSigning(devTeam: "K2H77582Z5"),
            xcconfig: .relativeToRoot("ConfigFiles/EssentialApp.xcconfig")
        )
    }
    
    static var essentialAppRelease: Self {
        .release(
            name: "Release",
            settings: SettingsDictionary()
                .manualCodeSigning(
                    identity: "Apple Distribution: Finn Ebeling (K2H77582Z5)",
                    provisioningProfileSpecifier: "EssentialAppDistributionProfile"
                ),
            xcconfig: .relativeToRoot("ConfigFiles/EssentialApp.xcconfig")
        )
    }
}

public extension ConfigurationName {
    static var essentialAppDebug: Self {
        .configuration("essentialAppDebug")
    }
    
    static var essentialAppRelease: Self {
        .configuration("essentialAppRelease")
    }
}

// MARK: - EssentialFeed

public extension Configuration {
    static var essentialFeedDebug: Self {
        .debug(name: "Debug", xcconfig: .relativeToRoot("ConfigFiles/EssentialFeed.xcconfig"))
    }
    
    static var essentialFeedRelease: Self {
        .release(name: "Release", xcconfig: .relativeToRoot("ConfigFiles/EssentialFeed.xcconfig"))
    }
}

public extension ConfigurationName {
    static var essentialFeedDebug: Self {
        .configuration("essentialFeedDebug")
    }
    
    static var essentialFeedRelease: Self {
        .configuration("essentialFeedRelease")
    }
}

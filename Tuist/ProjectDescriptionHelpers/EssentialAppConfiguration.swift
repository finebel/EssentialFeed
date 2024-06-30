import ProjectDescription

public extension Configuration {
    static var essentialAppDebug: Self {
        .debug(
            name: "Debug",
            settings: SettingsDictionary()
                .automaticCodeSigning(devTeam: "K2H77582Z5")
                .currentProjectVersion("1")
            ,
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
                )
                .currentProjectVersion("1")
            ,
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

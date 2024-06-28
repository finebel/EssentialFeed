import ProjectDescription

public extension Configuration {
    static var essentialAppDebug: Self {
        .debug(name: "Debug", xcconfig: .relativeToRoot("ConfigFiles/EssentialApp.xcconfig"))
    }
}

public extension ConfigurationName {
    static var essentialAppDebug: Self {
        .configuration("essentialAppDebug")
    }
}

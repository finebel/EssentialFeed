import ProjectDescription

public extension Configuration {
    static var essentialAppDebug: Self {
        .debug(name: "Debug", xcconfig: .relativeToRoot("ConfigFiles/EssentialApp.xcconfig"))
    }
    
    static var essentialAppRelease: Self {
        .release(name: "Release", xcconfig: .relativeToRoot("ConfigFiles/EssentialApp.xcconfig"))
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

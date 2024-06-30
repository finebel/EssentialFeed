import ProjectDescription


// MARK: - EssentialApp

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

import ProjectDescription

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

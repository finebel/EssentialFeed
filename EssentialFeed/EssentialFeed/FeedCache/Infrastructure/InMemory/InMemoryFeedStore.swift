//
//  InMemoryFeedStore.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 01.06.24.
//

import Foundation

public class InMemoryFeedStore {
    private(set) var feedCache: CachedFeed?
    private var feedImageDataCache: [URL: Data]
    
    public init(feedCache: CachedFeed? = nil, feedImageDataCache: [URL : Data] = [:]) {
        self.feedCache = feedCache
        self.feedImageDataCache = feedImageDataCache
    }
    
}

extension InMemoryFeedStore: FeedStore {
    public func deleteCachedFeed() throws {
        feedCache = nil
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        feedCache = CachedFeed(feed: feed, timestamp: timestamp)
    }
    
    public func retrieve() throws -> CachedFeed? {
        feedCache
    }
}

extension InMemoryFeedStore: FeedImageDataStore {
    public func retrieve(dataForURL url: URL) throws -> Data? {
        feedImageDataCache[url]
    }
    
    public func insert(_ data: Data, for url: URL) throws {
        feedImageDataCache[url] = data
    }
}

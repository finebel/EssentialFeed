//
//  NullStore.swift
//  EssentialApp
//
//  Created by Finn Ebeling on 23.05.24.
//

import Foundation
import EssentialFeed

class NullStore {}

extension NullStore: FeedStore {
    func deleteCachedFeed() throws {}
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {}
    
    func retrieve() throws -> CachedFeed? { nil }
}

extension NullStore: FeedImageDataStore {
    func retrieve(dataForURL url: URL) throws -> Data? { nil }
    
    func insert(_ data: Data, for url: URL) throws {}
}

//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 10.02.24.
//

import Foundation

public final class LocalFeedLoader {
    public typealias SaveResult = Error?
    
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] cacheDeletionError in
            guard let self else { return }
            
            if let cacheDeletionError {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }
    
    public func load(completion: @escaping (Error?) -> Void) {
        store.retrieve { error in
            completion(error)
        }
    }
    
    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] cacheInsertionError in
            guard self != nil else { return }
            completion(cacheInsertionError)
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        map {
            LocalFeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.url
            )
        }
    }
}

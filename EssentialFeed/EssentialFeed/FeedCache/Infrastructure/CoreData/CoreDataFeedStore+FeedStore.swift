//
//  CoreDataFeedStore+FeedStore.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 06.04.24.
//

import Foundation

extension CoreDataFeedStore: FeedStore {
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            let retrievalResult: FeedStore.RetrievalResult = Result {
                try ManagedCache.find(in: context).map {
                    CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            }
            
            completion(retrievalResult)
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            let insertResult: FeedStore.InsertionResult = Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                
                try context.save()
            }
            
            completion(insertResult)
        }
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            let deleteResult: FeedStore.DeletionResult = Result {
                try ManagedCache.find(in: context)
                    .map(context.delete)
                    .map(context.save)
            }
            completion(deleteResult)
        }
    }
}
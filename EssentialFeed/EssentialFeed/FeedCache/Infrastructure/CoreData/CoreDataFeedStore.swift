//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 20.02.24.
//

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {
    private let container: NSPersistentContainer
    
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        self.container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            let retrievalResult: RetrievalResult = Result {
                try ManagedCache.find(in: context).map {
                    return CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            }
            
            completion(retrievalResult)
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            let insertResult: InsertionResult = Result {
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
            let deleteResult: DeletionResult = Result {
                try ManagedCache.find(in: context)
                    .map(context.delete)
                    .map(context.save)
            }
            completion(deleteResult)
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}

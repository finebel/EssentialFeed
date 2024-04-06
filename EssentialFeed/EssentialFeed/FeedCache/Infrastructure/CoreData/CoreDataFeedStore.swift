//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 20.02.24.
//

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {
    private static let modelName = "FeedStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataFeedStore.self))
    
    private let container: NSPersistentContainer
    
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentStores(Error)
    }
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        guard let model = Self.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            self.container = try NSPersistentContainer.load(name: Self.modelName, model: model, url: storeURL, in: bundle)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentStores(error)
        }
    }
    
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
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}

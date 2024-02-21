//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 20.02.24.
//

import Foundation
import CoreData

public class CoreDataFeedStore: FeedStore {
    public init() {}
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
}

private class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date?
    @NSManaged var feed: NSOrderedSet?
}

private class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL?
    @NSManaged var cache: ManagedCache?
}

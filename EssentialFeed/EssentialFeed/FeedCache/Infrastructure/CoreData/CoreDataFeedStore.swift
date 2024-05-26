//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 20.02.24.
//

import Foundation
import CoreData

public final class CoreDataFeedStore {
    private static let modelName = "FeedStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataFeedStore.self))
    
    private let container: NSPersistentContainer
    
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentStores(Error)
    }
    
    public init(storeURL: URL) throws {
        let bundle = Bundle(for: Self.self)
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
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
    
    func performAsync(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }

    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        
        return try result.get()
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
}

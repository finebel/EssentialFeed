//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 10.02.24.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insertItems(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}


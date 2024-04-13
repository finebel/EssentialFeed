//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 13.04.24.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}

//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 13.04.24.
//

import Foundation

public protocol FeedCache {    
    func save(_ feed: [FeedImage]) throws
}

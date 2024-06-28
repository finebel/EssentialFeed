//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 13.04.24.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}

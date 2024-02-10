//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 03.02.24.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}

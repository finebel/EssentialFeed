//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 03.02.24.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (Result) -> Void)
}

//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 03.02.24.
//

import Foundation

typealias LoadFeedResult = Result<[FeedItem], Error>

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}

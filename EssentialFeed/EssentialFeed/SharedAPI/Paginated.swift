//
//  Paginated.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 18.05.24.
//

import Foundation

public struct Paginated<Item> {
    public typealias LoadMoreCompletion = (Result<Paginated<Item>, Error>) -> Void
    
    public let items: [Item]
    public let loadMore: ((@escaping LoadMoreCompletion) -> Void)?
    
    public init(items: [Item], loadMore: ((LoadMoreCompletion) -> Void)? = nil) {
        self.items = items
        self.loadMore = loadMore
    }
}

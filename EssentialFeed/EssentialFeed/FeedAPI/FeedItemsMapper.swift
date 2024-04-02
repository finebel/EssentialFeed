//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 05.02.24.
//

import Foundation

final class FeedItemsMapper {
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK,
              let root = try? JSONDecoder().decode(Root.self, from: data) else { throw RemoteFeedLoader.Error.invalidData }
        
        return root.items
    }
}

private extension FeedItemsMapper {
    struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
}

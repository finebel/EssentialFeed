//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 05.02.24.
//

import Foundation

final class FeedItemsMapper {
    private static let OK_200: Int = 200
        
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else { throw RemoteFeedLoader.Error.invalidData }
        
        return try JSONDecoder()
            .decode(Root.self, from: data)
            .items
            .map(\.feedItem)
    }
}

private extension FeedItemsMapper {
    struct Root: Decodable {
        let items: [Item]
    }

    struct Item: Decodable {
        public let id: UUID
        public let description: String?
        public let location: String?
        public let image: URL
        
        var feedItem: FeedItem {
            FeedItem(
                id: id,
                description: description,
                location: location,
                imageURL: image
            )
        }
    }
}

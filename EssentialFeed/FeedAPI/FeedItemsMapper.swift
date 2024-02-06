//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 05.02.24.
//

import Foundation

final class FeedItemsMapper {
    private static let OK_200: Int = 200
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else { return .failure(RemoteFeedLoader.Error.invalidData) }
        
        return .success(root.feedItems)
    }
}

private extension FeedItemsMapper {
    struct Root: Decodable {
        let items: [Item]
        
        var feedItems: [FeedItem] {
            items.map(\.feedItem)
        }
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

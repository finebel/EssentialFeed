//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 04.02.24.
//

import Foundation

public typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(fromURL url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
 
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<[FeedItem], Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(fromURL: url) { result in
            switch result {
            case let .success((data, response)):
                do {
                    let feedItems = try FeedItemsMapper.map(data, response)
                    completion(.success(feedItems))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private class FeedItemsMapper {
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == 200 else { throw RemoteFeedLoader.Error.invalidData }
        
        return try JSONDecoder()
            .decode(Root.self, from: data)
            .items
            .map(\.feedItem)
    }
}

private extension FeedItemsMapper {
    private struct Root: Decodable {
        let items: [Item]
    }

    private struct Item: Decodable {
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

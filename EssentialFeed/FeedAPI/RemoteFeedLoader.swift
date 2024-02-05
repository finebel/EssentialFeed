//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 04.02.24.
//

import Foundation

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

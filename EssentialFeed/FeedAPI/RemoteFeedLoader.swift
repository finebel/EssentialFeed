//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 04.02.24.
//

import Foundation

public protocol HTTPClient {
    func get(fromURL url: URL, completion: @escaping (Error) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
 
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Error) -> Void = { _ in }) {
        client.get(fromURL: url) { error in
            completion(.connectivity)
        }
    }
}

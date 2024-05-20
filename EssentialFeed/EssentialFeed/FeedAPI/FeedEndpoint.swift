//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 12.05.24.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path().appending("/v1/feed")
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10")
            ]
            
            return components.url!
        }
    }
}

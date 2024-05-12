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
            baseURL.appending(path: "/v1/feed")
        }
    }
}

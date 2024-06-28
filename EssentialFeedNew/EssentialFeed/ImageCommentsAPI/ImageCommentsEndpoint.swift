//
//  ImageCommentsEndpoint.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 12.05.24.
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            baseURL.appending(path: "/v1/image/\(id)/comments")
        }
    }
}

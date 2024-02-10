//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 10.02.24.
//

import Foundation

struct RemoteFeedItem: Decodable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let image: URL
}

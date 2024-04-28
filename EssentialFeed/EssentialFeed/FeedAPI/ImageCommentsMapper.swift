//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 28.04.24.
//

import Foundation

final class ImageCommentsMapper {
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK,
              let root = try? JSONDecoder().decode(Root.self, from: data) else { throw RemoteImageCommentsLoader.Error.invalidData }
        
        return root.items
    }
}

private extension ImageCommentsMapper {
    struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
}

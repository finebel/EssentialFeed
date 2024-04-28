//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 28.04.24.
//

import Foundation

final class ImageCommentsMapper {
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard Self.isOK(response),
              let root = try? JSONDecoder().decode(Root.self, from: data) else { throw RemoteImageCommentsLoader.Error.invalidData }
        
        return root.items
    }
    
    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        response.statusCode >= 200 && response.statusCode <= 299
    }
}

private extension ImageCommentsMapper {
    struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
}

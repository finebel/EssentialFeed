//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 28.04.24.
//

import Foundation

final class ImageCommentsMapper {
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [ImageComment] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard Self.isOK(response),
              let root = try? decoder.decode(Root.self, from: data) else { throw RemoteImageCommentsLoader.Error.invalidData }
        
        return root.comments
    }
    
    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        response.statusCode >= 200 && response.statusCode <= 299
    }
    
    private struct Root: Decodable {
        private let items: [Item]
        
        private struct Item: Decodable {
            let id: UUID
            let message: String
            let created_at: Date
            let author: Author
            
            struct Author: Decodable {
                let username: String
            }
        }
        
        var comments: [ImageComment] {
            items.map {
                ImageComment(
                    id: $0.id,
                    message: $0.message,
                    createdAt: $0.created_at,
                    username: $0.author.username
                )
            }
        }
    }
}

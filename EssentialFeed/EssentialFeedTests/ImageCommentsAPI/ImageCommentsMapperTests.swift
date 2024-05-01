//
//  ImageCommentsMapperTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 28.04.24.
//

import XCTest
import EssentialFeed

final class ImageCommentsMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
        let json = makeItemsJson([])
        let non200HTTPStatuses = [150, 199, 300, 400, 500]
        
        try non200HTTPStatuses.forEach { statusCode in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: statusCode))
            )
        }
    }
    
    func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        let valid2xxHTTPResponses = [200, 201, 250, 298, 299]
        
        try valid2xxHTTPResponses.forEach { statusCode in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: statusCode))
            )
        }
    }
    
    func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJson([])
        let valid2xxHTTPResponses = [200, 201, 250, 298, 299]
        
        try valid2xxHTTPResponses.forEach { statusCode in
            let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: statusCode))
            
            XCTAssertTrue(result.isEmpty)
        }
    }
    
    func test_map_deliversItemsOn2xxHTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: UUID(),
            message: "a message",
            createdAt: (date: Date(timeIntervalSince1970: 1598627222), iso8601String: "2020-08-28T15:07:02+00:00"),
            username: "a username"
        )
        let item2 = makeItem(
            id: UUID(),
            message: "another message",
            createdAt: (date: Date(timeIntervalSince1970: 1577881882), iso8601String: "2020-01-01T12:31:22+00:00"),
            username: "another username"
        )
        let json = makeItemsJson([item1.json, item2.json])
        let valid2xxHTTPResponses = [200, 201, 250, 298, 299]
        
        try valid2xxHTTPResponses.forEach { statusCode in
            let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: statusCode))
            
            XCTAssertEqual(result, [item1.model, item2.model])
        }
    }
    
    // MARK: - Helpers
    private func makeItem(
        id: UUID,
        message: String,
        createdAt: (date: Date, iso8601String: String),
        username: String
    ) -> (model: ImageComment, json: [String: Any]) {
        let model = ImageComment(
            id: id,
            message: message,
            createdAt: createdAt.date,
            username: username
        )
        
        let json: [String: Any] = [
            "id": id.uuidString,
            "message": message,
            "created_at": createdAt.iso8601String,
            "author": [
                "username": username
            ]
        ]
        
        return (model, json)
    }
}

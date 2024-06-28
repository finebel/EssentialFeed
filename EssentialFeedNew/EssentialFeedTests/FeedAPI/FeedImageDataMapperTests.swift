//
//  FeedImageDataMapperTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 01.05.24.
//

import XCTest
import EssentialFeed

final class FeedImageDataMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let non200HTTPStatuses = [199, 201, 300, 400, 500]
                
        try non200HTTPStatuses.forEach { statusCode in
            XCTAssertThrowsError(
                try FeedImageDataMapper.map(anyData(), from: HTTPURLResponse(statusCode: statusCode))
            )
        }
    }
    
    func test_map_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() {
        let emptyData = Data()
        
        XCTAssertThrowsError(
            try FeedImageDataMapper.map(emptyData, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversDataOn200HTTPResponseWithNonEmptyData() throws {
        let nonEmptyData = "non-empty data".data(using: .utf8)!
        
        let result = try FeedImageDataMapper.map(nonEmptyData, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, nonEmptyData)
    }
}

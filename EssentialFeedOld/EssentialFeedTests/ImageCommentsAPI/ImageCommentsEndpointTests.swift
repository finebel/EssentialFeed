//
//  ImageCommentsEndpointTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 12.05.24.
//

import XCTest
import EssentialFeed

final class ImageCommentsEndpointTests: XCTestCase {
    func test_imageComments_endpointURL() {
        let imageID = UUID(uuidString: "6BFF704D-A813-4E39-BCA8-85E4CB6C5472")!
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = ImageCommentsEndpoint.get(imageID).url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/v1/image/6BFF704D-A813-4E39-BCA8-85E4CB6C5472/comments")!
        
        XCTAssertEqual(received, expected)
    }
}

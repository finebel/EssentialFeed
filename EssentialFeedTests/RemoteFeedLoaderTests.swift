//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 03.02.24.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(fromURL: URL(string: "https://www.google.com/")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    
    func get(fromURL url: URL) {}
}

class HTTPClientSpy: HTTPClient {
    override func get(fromURL url: URL) {
        requestedURL = url
    }
    
    var requestedURL: URL?
}

final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}

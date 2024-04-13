//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Finn Ebeling on 11.04.24.
//

import Foundation
import EssentialFeed

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    "any data".data(using: .utf8)!
}

func anyURL() -> URL {
    URL(string: "http://a-url.com")!
}

func uniqueFeed() -> [FeedImage] {
    [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}

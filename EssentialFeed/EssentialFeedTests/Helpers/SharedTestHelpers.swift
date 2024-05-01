//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 11.02.24.
//

import Foundation

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 1)
}

func anyData() -> Data {
    "any data".data(using: .utf8)!
}

func makeItemsJson(_ items: [[String: Any]]) -> Data {
    let itemsJson = ["items": items]
    return try! JSONSerialization.data(withJSONObject: itemsJson)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

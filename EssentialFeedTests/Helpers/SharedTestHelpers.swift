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

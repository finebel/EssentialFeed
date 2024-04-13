//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Finn Ebeling on 13.04.24.
//

import Foundation
import EssentialFeed

class FeedLoaderStub: FeedLoader {
    let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}

//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 06.04.24.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
        
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}

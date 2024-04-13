//
//  FeedImageDataLoaderSpy.swift
//  EssentialAppTests
//
//  Created by Finn Ebeling on 13.04.24.
//

import Foundation
import EssentialFeed

class FeedImageDataLoaderSpy: FeedImageDataLoader {
    private struct Task: FeedImageDataLoaderTask {
        var callback: () -> Void
        func cancel() { callback() }
    }
    
    private var completions: [(url: URL, completion: ((FeedImageDataLoader.Result) -> Void))] = []
    
    var loadedURLs: [URL] {
        completions.map(\.url)
    }
    
    private(set) var cancelledURLs: [URL] = []
    
    func loadImageData(from url: URL, completion: @escaping ((FeedImageDataLoader.Result) -> Void)) -> FeedImageDataLoaderTask {
        completions.append((url, completion))
        
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }
    
    func complete(withData data: Data, at index: Int = 0) {
        completions[index].completion(.success(data))
    }
    
    func complete(withError error: Error, at index: Int = 0) {
        completions[index].completion(.failure(error))
    }
}

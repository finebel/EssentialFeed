//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Finn Ebeling on 09.04.24.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    private struct Task: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
    private let primary: FeedImageDataLoader
    private let fallback: FeedImageDataLoader
    
    init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func loadImageData(from url: URL, completion: @escaping ((FeedImageDataLoader.Result) -> Void)) -> FeedImageDataLoaderTask {
        _ = primary.loadImageData(from: url) { _ in }
        return Task()
    }
}

final class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {
    func test_init_doesNotLoadImageData() {
        let primary = LoaderSpy()
        let fallback = LoaderSpy()
        
        _ = FeedImageDataLoaderWithFallbackComposite(primary: primary, fallback: fallback)
        
        XCTAssertTrue(primary.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
        XCTAssertTrue(fallback.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    func test_loadImageData_loadsFromPrimaryLoaderFirst() {
        let primary = LoaderSpy()
        let fallback = LoaderSpy()
        let url = anyURL()
        
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primary, fallback: fallback)
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(primary.loadedURLs, [url] , "Expected to load URL from primary loader")
        XCTAssertTrue(fallback.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    // MARK: - Helpers
        
    private func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
    
    private class LoaderSpy: FeedImageDataLoader {
        private struct Task: FeedImageDataLoaderTask {
            func cancel() {}
        }
        
        private var completions: [(url: URL, completion: ((FeedImageDataLoader.Result) -> Void))] = []
        var loadedURLs: [URL] {
            completions.map(\.url)
        }
        
        func loadImageData(from url: URL, completion: @escaping ((FeedImageDataLoader.Result) -> Void)) -> FeedImageDataLoaderTask {
            completions.append((url, completion))
            
            return Task()
        }
        
        func complete(withData data: Data, at index: Int = 0) {
            completions[index].completion(.success(data))
        }
    }
}

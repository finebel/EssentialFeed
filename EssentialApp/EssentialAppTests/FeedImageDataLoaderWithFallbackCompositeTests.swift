//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Finn Ebeling on 09.04.24.
//

import XCTest
import EssentialFeed
import EssentialApp

final class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {
    func test_init_doesNotLoadImageData() {
        let (_, primary, fallback) = makeSUT()
        
        XCTAssertTrue(primary.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
        XCTAssertTrue(fallback.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    func test_loadImageData_loadsFromPrimaryLoaderFirst() {
        let (sut, primary, fallback) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(primary.loadedURLs, [url] , "Expected to load URL from primary loader")
        XCTAssertTrue(fallback.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    func test_loadImageData_loadsFromFallbackOnPrimaryLoaderFailure() {
        let (sut, primary, fallback) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        primary.complete(withError: anyNSError())
        
        XCTAssertEqual(primary.loadedURLs, [url] , "Expected to load URL from primary loader")
        XCTAssertEqual(fallback.loadedURLs, [url] , "Expected to load URL from fallback loader after primary loader failed")
    }
    
    func test_cancelLoadImageData_cancelsPrimaryLoaderTask() {
        let (sut, primary, fallback) = makeSUT()
        let url = anyURL()
        
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(primary.cancelledURLs, [url] , "Expected to cancel URL loading from primary loader")
        XCTAssertTrue(fallback.cancelledURLs.isEmpty, "Expected no cancelled URLs in the fallback loader")
    }
    
    func test_cancelLoadImageData_cancelsFallbackLoaderTaskAfterPrimaryLoaderFailure() {
        let (sut, primary, fallback) = makeSUT()
        let url = anyURL()
        
        let task = sut.loadImageData(from: url) { _ in }
        primary.complete(withError: anyNSError())
        task.cancel()
        
        XCTAssertTrue(primary.cancelledURLs.isEmpty, "Expected no cancelled URLs in the primary loader")
        XCTAssertEqual(fallback.cancelledURLs, [url] , "Expected to cancel URL loading from fallback loader")
    }
    
    func test_loadImageData_deliversPrimaryDataOnPrimaryLoaderSuccess() {
        let (sut, primary, _) = makeSUT()
        let primaryData = anyData()
        
        expect(sut, toCompleteWith: .success(primaryData)) {
            primary.complete(withData: primaryData)
        }
    }
    
    func test_loadImageData_deliversFallbackDataOnFallbackLoaderSuccess() {
        let (sut, primary, fallback) = makeSUT()
        let fallbackData = anyData()
        
        expect(sut, toCompleteWith: .success(fallbackData)) {
            primary.complete(withError: anyNSError())
            fallback.complete(withData: fallbackData)
        }
    }
    
    func test_loadImageData_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
        let (sut, primary, fallback) = makeSUT()
                
        expect(sut, toCompleteWith: .failure(anyNSError())) {
            primary.complete(withError: anyNSError())
            fallback.complete(withError: anyNSError())
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoader, primary: LoaderSpy, fallback: LoaderSpy) {
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        trackForMemoryLeaks(instance: primaryLoader, file: file, line: line)
        trackForMemoryLeaks(instance: fallbackLoader, file: file, line: line)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        
        return (sut, primaryLoader, fallbackLoader)
    }
        
    private func expect(
        _ sut: FeedImageDataLoader,
        toCompleteWith expectedResult: FeedImageDataLoader.Result,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")

        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedImageData), .success(expectedImageData)):
                XCTAssertEqual(receivedImageData, expectedImageData, file: file, line: line)

            case (.failure, .failure):
                break

            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
    
    private class LoaderSpy: FeedImageDataLoader {
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
}

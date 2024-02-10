//
//  LoadFeedFromCacheUseCase.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 10.02.24.
//

import XCTest
import EssentialFeed

final class LoadFeedFromCacheUseCase: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load() { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let exp = expectation(description: "Wait for load completion")
        let retrievalError = anyNSError()
        
        var receivedError: Error?
        sut.load { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure, but got \(result) instead")
            }
            exp.fulfill()
        }
        
        store.completeRetrieval(withError: retrievalError)
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(receivedError as? NSError, retrievalError)
    }
    
    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()
        let exp = expectation(description: "Wait for load completion")
        
        var receivedImages: [FeedImage]?
        sut.load { result in
            switch result {
            case let .success(feedImages):
                receivedImages = feedImages
            default:
                XCTFail("Expected success, but got \(result) instead")
            }
            exp.fulfill()
        }
        
        store.completeRetrievalWithEmptyCache()
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(receivedImages, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(instance: store, file: file, line: line)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        
        return (sut: sut, store: store)
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
}

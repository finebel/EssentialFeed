//
//  CoreDataFeedImageDataStoreTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 06.04.24.
//

import XCTest
import EssentialFeed

final class CoreDataFeedImageDataStoreTests: XCTestCase, FeedImageDataStoreSpecs {
    func test_retrieveImageData_deliversNotFoundWhenEmpty() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveImageDataDeliversNotFoundWhenEmpty(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveImageDataDeliversLastInsertedValue(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(_ test: @escaping (CoreDataFeedStore, URL) -> Void, file: StaticString = #file, line: UInt = #line) throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        
        let exp = expectation(description: "Wait for operation")
        sut.perform {
            let imageDataURL = URL(string: "https://a-url.com")!
            insertFeedImage(with: imageDataURL, into: sut, file: file, line: line)
            test(sut, imageDataURL)
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

private func insertFeedImage(with url: URL, into sut: CoreDataFeedStore, file: StaticString = #file, line: UInt = #line) {
    do {
        let image = LocalFeedImage(id: UUID(), description: "a description", location: "a location", url: url)
        try sut.insert([image], timestamp: .now)
    } catch {
        XCTFail("Failed to insert with error \(error)", file: file, line: line)
    }
}

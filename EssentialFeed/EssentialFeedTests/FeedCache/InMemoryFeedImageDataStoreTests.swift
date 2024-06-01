//
//  InMemoryFeedImageDataStoreTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 01.06.24.
//

import XCTest
import EssentialFeed

final class InMemoryFeedImageDataStoreTests: XCTestCase, FeedImageDataStoreSpecs {
    func test_retrieveImageData_deliversNotFoundWhenEmpty() throws {
        let sut = makeSUT()
        
        assertThatRetrieveImageDataDeliversNotFoundWhenEmpty(on: sut)
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws {
        let sut = makeSUT()
        
        assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut)
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws {
        let sut = makeSUT()
        
        assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() throws {
        let sut = makeSUT()
        
        assertThatRetrieveImageDataDeliversLastInsertedValue(on: sut)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedImageDataStore {
        let sut = InMemoryFeedStore()
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        
        return sut
    }
}

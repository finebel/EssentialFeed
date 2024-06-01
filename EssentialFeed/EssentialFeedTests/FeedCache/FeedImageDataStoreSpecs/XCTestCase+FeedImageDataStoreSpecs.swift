//
//  XCTestCase+FeedImageDataStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 01.06.24.
//

import Foundation
import XCTest
import EssentialFeed

extension FeedImageDataStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveImageDataDeliversNotFoundWhenEmpty(
        on sut: FeedImageDataStore,
        imageDataURL: URL,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toCompleteRetrievalWith: notFound(), for: imageDataURL, file: file, line: line)
    }
    
    func assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(
        on sut: FeedImageDataStore,
        imageDataURL: URL,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let nonMatchingURL = URL(string: "http://another-url.com")!
        
        insert(anyData(), for: imageDataURL, into: sut)
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingURL, file: file, line: line)
    }
    
    func assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(
        on sut: FeedImageDataStore,
        imageDataURL: URL,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let storedData = anyData()
        
        insert(storedData, for: imageDataURL, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(storedData), for: imageDataURL, file: file, line: line)
    }
    
    func assertThatRetrieveImageDataDeliversLastInsertedValue(
        on sut: FeedImageDataStore,
        imageDataURL: URL,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let firstStoredData = "first".data(using: .utf8)!
        let lastStoredData = "last".data(using: .utf8)!
        
        insert(firstStoredData, for: imageDataURL, into: sut)
        insert(lastStoredData, for: imageDataURL, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(lastStoredData), for: imageDataURL)
    }
}

extension FeedImageDataStoreSpecs where Self: XCTestCase {
    private func notFound() -> Result<Data?, Error> {
        .success(.none)
    }

    private func found(_ data: Data) -> Result<Data?, Error> {
        .success(data)
    }

    private func localImage(url: URL) -> LocalFeedImage {
        LocalFeedImage(id: UUID(), description: "any", location: "any", url: url)
    }

    private func expect(
        _ sut: FeedImageDataStore,
        toCompleteRetrievalWith expectedResult: Result<Data?, Error>,
        for url: URL,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let receivedResult = Result { try sut.retrieve(dataForURL: url) }

        switch (receivedResult, expectedResult) {
        case let (.success(receivedData), .success(expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)

        default:
            XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }

    private func insert(_ data: Data, for url: URL, into sut: FeedImageDataStore, file: StaticString = #file, line: UInt = #line) {
        do {
            try sut.insert(data, for: url)
        } catch {
            XCTFail("Failed to insert image data: \(data) - error \(error)", file: file, line: line)
        }
    }
}

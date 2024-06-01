//
//  CoreDataFeedImageDataStoreTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 06.04.24.
//

import XCTest
import EssentialFeed

final class CoreDataFeedImageDataStoreTests: XCTestCase {
    func test_retrieveImageData_deliversNotFoundWhenEmpty() throws {
        try makeSUT { sut in
            expect(sut, toCompleteRetrievalWith: notFound(), for: anyURL())
        }
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws {
        try makeSUT { sut in
            let url = URL(string: "http://a-url.com")!
            let nonMatchingURL = URL(string: "http://another-url.com")!
            
            insert(anyData(), for: url, into: sut)
            
            expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingURL)
        }
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws {
        try makeSUT { sut in
            let storedData = anyData()
            let url = URL(string: "http://a-url.com")!
            
            insert(storedData, for: url, into: sut)
            
            expect(sut, toCompleteRetrievalWith: found(storedData), for: url)
        }
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() throws {
        try makeSUT { sut in
            let firstStoredData = "first".data(using: .utf8)!
            let lastStoredData = "last".data(using: .utf8)!
            let url = URL(string: "http://a-url.com")!
            
            insert(firstStoredData, for: url, into: sut)
            insert(lastStoredData, for: url, into: sut)
            
            expect(sut, toCompleteRetrievalWith: found(lastStoredData), for: url)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(_ test: @escaping (CoreDataFeedStore) -> Void, file: StaticString = #file, line: UInt = #line) throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        
        let exp = expectation(description: "Wait for operation")
        sut.perform {
            test(sut)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

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

private func insert(_ data: Data, for url: URL, into sut: CoreDataFeedStore, file: StaticString = #file, line: UInt = #line) {
    do {
        let image = localImage(url: url)
        try sut.insert([image], timestamp: Date())
        try sut.insert(data, for: url)
    } catch {
        XCTFail("Failed to insert with error \(error)", file: file, line: line)
    }
}

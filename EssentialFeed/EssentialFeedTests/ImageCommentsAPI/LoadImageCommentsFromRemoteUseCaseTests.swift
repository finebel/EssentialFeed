//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 28.04.24.
//

import XCTest
import EssentialFeed

final class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {
    func test_load_deliversErrorOnNon2xxHTTPResponse() {
        let (sut, client) = makeSUT()
        
        let non200HTTPStatuses = [150, 199, 300, 400, 500]
        non200HTTPStatuses.enumerated().forEach { index, statusCode in
            expect(
                sut,
                toCompleteWithResult: .failure(RemoteImageCommentsLoader.Error.invalidData),
                when: {
                    let json = makeItemsJson([])
                    client.complete(withStatusCode: statusCode, data: json, at: index)
                }
            )
        }
    }
    
    func test_load_deliversErrorOn2xxHTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        let valid2xxHTTPResponses = [200, 201, 250, 298, 299]
        
        valid2xxHTTPResponses.enumerated().forEach { index, statusCode in
            expect(
                sut,
                toCompleteWithResult: failure(.invalidData),
                when: {
                    let invalidJSON = Data("invalid json".utf8)
                    client.complete(withStatusCode: statusCode, data: invalidJSON, at: index)
                }
            )
        }
    }
    
    func test_load_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        let valid2xxHTTPResponses = [200, 201, 250, 298, 299]
        
        valid2xxHTTPResponses.enumerated().forEach { index, statusCode in
            expect(
                sut,
                toCompleteWithResult: .success([]),
                when: {
                    let emptyListJSON = makeItemsJson([])
                    client.complete(withStatusCode: statusCode, data: emptyListJSON, at: index)
                }
            )
        }
    }
    
    func test_load_deliversItemsOn2xxHTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(
            id: UUID(),
            message: "a message",
            createdAt: (date: Date(timeIntervalSince1970: 1598627222), iso8601String: "2020-08-28T15:07:02+00:00"),
            username: "a username"
        )
        
        let item2 = makeItem(
            id: UUID(),
            message: "another message",
            createdAt: (date: Date(timeIntervalSince1970: 1577881882), iso8601String: "2020-01-01T12:31:22+00:00"),
            username: "another username"
        )
       
        let items = [item1.model, item2.model]
        
        let valid2xxHTTPResponses = [200, 201, 250, 298, 299]
        
        valid2xxHTTPResponses.enumerated().forEach { index, statusCode in
            expect(
                sut,
                toCompleteWithResult: .success(items),
                when: {
                    let json = makeItemsJson([item1.json, item2.json])
                    client.complete(withStatusCode: statusCode, data: json, at: index)
                }
            )
        }
    }
    
    // MARK: - Helpers
    private func makeSUT(
        url: URL = URL(string: "https://a-given-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteImageCommentsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteImageCommentsLoader(url: url, client: client)
        
        trackForMemoryLeaks(instance: client, file: file, line: line)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
                
        return (sut, client)
    }
    
    private func makeItem(
        id: UUID,
        message: String,
        createdAt: (date: Date, iso8601String: String),
        username: String
    ) -> (model: ImageComment, json: [String: Any]) {
        let model = ImageComment(
            id: id,
            message: message,
            createdAt: createdAt.date,
            username: username
        )
        
        let json: [String: Any] = [
            "id": id.uuidString,
            "message": message,
            "created_at": createdAt.iso8601String,
            "author": [
                "username": username
            ]
        ]
        
        return (model, json)
    }
    
    private func makeItemsJson(_ items: [[String: Any]]) -> Data {
        let itemsJson = ["items": items]
        return try! JSONSerialization.data(withJSONObject: itemsJson)
    }
    
    private func expect(
        _ sut: RemoteImageCommentsLoader,
        toCompleteWithResult expectedResult: RemoteImageCommentsLoader.Result,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteImageCommentsLoader.Error), .failure(expectedError as RemoteImageCommentsLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failure(_ error: RemoteImageCommentsLoader.Error) -> RemoteImageCommentsLoader.Result {
        .failure(error)
    }

}

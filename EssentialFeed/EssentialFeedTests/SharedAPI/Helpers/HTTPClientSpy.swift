//
//  HTTPClientSpy.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 01.04.24.
//

import Foundation
import EssentialFeed

class HTTPClientSpy: HTTPClient {
    private struct Task: HTTPClientTask {
        var onCancel: () -> Void
        func cancel() {
            onCancel()
        }
    }
    
    private var messages: [(url: URL, completion: (HTTPClient.Result) -> Void)] = []
    private(set) var cancelledURLs: [URL] = []
    
    var requestedURLs: [URL] {
        messages.map(\.url)
    }
    
    func get(fromURL url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        return Task(onCancel: { [weak self] in
            self?.cancelledURLs.append(url)
        })
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode statusCode: Int, data: Data, at index: Int = 0) {
        let httpURLResponse = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success((data, httpURLResponse)))
    }
}

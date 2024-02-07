//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 07.02.24.
//

import XCTest
import EssentialFeed

protocol HTTPSessionTask {
    func resume()
}

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask
}

class URLSessionHTTPClient {
    private let session: HTTPSession
    
    init(session: HTTPSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        let dataTask = session.dataTask(with: url) { _, _, error in
            if let error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "https://a-url.com")!
        let dataTask = URLSessionDataTaskSpy()
        let session = HTTPSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        session.stub(url: url, task: dataTask)
        
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(dataTask.resumeCallCount, 1)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://a-url.com")!
        let error = NSError(domain: "any error", code: 1)
        let session = HTTPSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        session.stub(url: url, error: error)
        
        let exp = expectation(description: "Completion handler is called once")
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.domain, error.domain)
                XCTAssertEqual(receivedError.code, error.code)
            default:
                XCTFail("Expected failure with NSError, but got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: - Helper
    
    private class HTTPSessionSpy: HTTPSession {
        private var stubs: [URL: Stub] = [:]
        
        private struct Stub {
            let task: HTTPSessionTask
            let error: Error?
        }
        
        func stub(
            url: URL,
            task: HTTPSessionTask = FakeURLSessionDataTask(),
            error: Error? = nil
        ) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask {
            guard let stub = stubs[url] else { fatalError("Didn't find a stub for \(url)") }
            
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }
    
    private class FakeURLSessionDataTask: HTTPSessionTask {
        func resume() {}
    }
    
    private class URLSessionDataTaskSpy: HTTPSessionTask {
        private(set) var resumeCallCount: Int = 0
        
        func resume() {
            resumeCallCount += 1
        }
    }
}

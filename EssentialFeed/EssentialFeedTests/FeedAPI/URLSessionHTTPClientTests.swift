//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 07.02.24.
//

import XCTest
import EssentialFeed

final class URLSessionHTTPClientTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.removeStub()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        
        let exp = expectation(description: "Wait for request")
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            
            exp.fulfill()
        }
        
        makeSUT().get(fromURL: url, completion: { _ in })
        
        wait(for: [exp])
    }
    
    func test_getFromURL_failsOnRequestError() {
        let requestError = anyNSError()
        let receivedError = resultErrorFor(values: (data: nil, response: nil, error: requestError)) as? NSError
        
        XCTAssertEqual(receivedError?.domain, requestError.domain)
        XCTAssertEqual(receivedError?.code, requestError.code)
    }
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultErrorFor(values: (data: nil, response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor(values: (data: nil, response: nonHTTPURLResponse(), error: nil)))
        XCTAssertNotNil(resultErrorFor(values: (data: anyData(), response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor(values: (data: anyData(), response: nil, error: anyNSError())))
        XCTAssertNotNil(resultErrorFor(values: (data: nil, response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor(values: (data: nil, response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor(values: (data: anyData(), response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor(values: (data: anyData(), response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor(values: (data: anyData(), response: nonHTTPURLResponse(), error: nil)))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let expectedData = anyData()
        let expectedResponse = anyHTTPURLResponse()

        let receivedValues = resultValuesFor(values: (data: expectedData, response: expectedResponse, error: nil))
        
        XCTAssertEqual(receivedValues?.data, expectedData)
        XCTAssertEqual(receivedValues?.response.statusCode, expectedResponse.statusCode)
        XCTAssertEqual(receivedValues?.response.url, expectedResponse.url)
    }
    
    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let expectedResponse = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor(values: (data: nil, response: expectedResponse, error: nil))
        
        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.statusCode, expectedResponse.statusCode)
        XCTAssertEqual(receivedValues?.response.url, expectedResponse.url)
    }
    
    func test_cancelGetFromURLTask_cancelsURLRequest() {
        var task: HTTPClientTask?
        URLProtocolStub.onStartLoading { task?.cancel() }
        
        let receivedError = resultErrorFor(taskHandler: { task = $0 }) as? NSError
        
        XCTAssertEqual(receivedError?.code, URLError.cancelled.rawValue)
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return sut
    }
    
    private func resultValuesFor(
        values: (data: Data?, response: URLResponse?, error: Error?)? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (data: Data, response: HTTPURLResponse)? {
        let result = resultFor(values: values, file: file, line: line)
        
        switch result {
        case let .success(successValues):
            return successValues
        default:
            XCTFail("Expected success, but got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultErrorFor(
        values: (data: Data?, response: URLResponse?, error: Error?)? = nil,
        taskHandler: (HTTPClientTask) -> Void = { _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Error? {
        let result = resultFor(values: values, taskHandler: taskHandler, file: file, line: line)
        
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure, but got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultFor(
        values: (data: Data?, response: URLResponse?, error: Error?)?,
        taskHandler: (HTTPClientTask) -> Void = { _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> HTTPClient.Result {
        values.map { URLProtocolStub.stub(data: $0.data, response: $0.response, error: $0.error) }
        let sut = makeSUT(file: file, line: line)
        var receivedResult: HTTPClient.Result!
        
        let exp = expectation(description: "Completion handler is called once")
        let task = sut.get(fromURL: anyURL()) { result in
            receivedResult = result
            exp.fulfill()
        }
        taskHandler(task)
        
        wait(for: [exp], timeout: 1)
        return receivedResult
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
}

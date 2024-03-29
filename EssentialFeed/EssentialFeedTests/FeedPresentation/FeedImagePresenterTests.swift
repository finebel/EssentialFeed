//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 29.03.24.
//

import XCTest

class FeedImagePresenter {
    init(view: Any) {
        
    }
}

final class FeedImagePresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages upon creation")
    }
    
    // MARK: - Helpers
        
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(instance: view, file: file, line: line)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy {
        var messages: [Any] = []
    }
}

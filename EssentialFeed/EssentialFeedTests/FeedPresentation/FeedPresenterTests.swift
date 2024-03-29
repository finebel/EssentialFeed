//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 29.03.24.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()

        _ = FeedPresenter(view: view)

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages upon creation")
    }
    
    // MARK: - Helpers
    
    private class ViewSpy {
        let messages: [Any] = []
    }
}

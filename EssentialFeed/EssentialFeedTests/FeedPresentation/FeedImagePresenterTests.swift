//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 29.03.24.
//

import XCTest
import EssentialFeed

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let image: Any?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        location != nil
    }
}

protocol FeedImageView {
    func display(_ model: FeedImageViewModel)
}

class FeedImagePresenter {
    private let view: FeedImageView
    
    init(view: FeedImageView) {
        self.view = view
    }
    
    func didStartLoadingImageData(for model: FeedImage) {
        view.display(
            FeedImageViewModel(
                description: model.description,
                location: model.location,
                image: nil,
                isLoading: true,
                shouldRetry: false
            )
        )
    }
}

final class FeedImagePresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages upon creation")
    }
    
    func test_didStartLoadingImageData_displaysLoadingImageData() {
        let (sut, view) = makeSUT()
        let uniqueImage = uniqueImage()
        
        sut.didStartLoadingImageData(for: uniqueImage)
        
        XCTAssertEqual(view.messages.count, 1)
        let message = view.messages.first
        XCTAssertEqual(message?.description, uniqueImage.description)
        XCTAssertEqual(message?.location, uniqueImage.location)
        XCTAssertNil(message?.image)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertEqual(message?.shouldRetry, false)
    }
    
    // MARK: - Helpers
        
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(instance: view, file: file, line: line)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: FeedImageView {
        var messages: [FeedImageViewModel] = []
        
        func display(_ model: FeedImageViewModel) {
            messages.append(model)
        }
    }
}

//
//  LoadResourcePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 02.05.24.
//

import XCTest
import EssentialFeed

final class LoadResourcePresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages upon creation")
    }
    
    func test_didStartLoading_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: nil),
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingResource_displaysResourceAndStopsLoading() {
        let (sut, view) = makeSUT(mapper: { resource in
            resource + " view model"
        })
        
        sut.didFinishLoading(with: "resource")
        
        XCTAssertEqual(view.messages, [
            .display(resourceViewModel: "resource view model"),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingWithMapperError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT(mapper: { resource in
            throw anyNSError()
        })
        
        sut.didFinishLoading(with: "resource")
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: localized("GENERIC_CONNECTION_ERROR")),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoadingWithError(with: anyNSError())
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: localized("GENERIC_CONNECTION_ERROR")),
            .display(isLoading: false)
        ])
    }
    
    // MARK: - Helpers
    
    private typealias LoadResourcePresenter = EssentialFeed.LoadResourcePresenter<String, ViewSpy>
    
    private func makeSUT(
        mapper: @escaping LoadResourcePresenter.Mapper = { _ in "any" },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LoadResourcePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = LoadResourcePresenter(
            resourceView: view,
            loadingView: view,
            errorView: view,
            mapper: mapper
        )
        trackForMemoryLeaks(instance: view, file: file, line: line)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: ResourceErrorView, ResourceLoadingView, ResourceView {
        typealias ResourceViewModel = String
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(resourceViewModel: String)
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: ResourceErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: ResourceLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: String) {
            messages.insert(.display(resourceViewModel: viewModel))
        }
    }
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        
        return value
    }

}

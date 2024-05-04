//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 29.03.24.
//

import XCTest
import EssentialFeed

final class FeedImagePresenterTests: XCTestCase {
    func test_map_createsViewModel() {
        let image = uniqueImage()
        
        let viewModel = FeedImagePresenter.map(image)
        
        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location)
    }
}

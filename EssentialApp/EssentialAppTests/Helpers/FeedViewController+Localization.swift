//
//  FeedViewController+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Finn Ebeling on 17.03.24.
//

import XCTest
import EssentialFeed

extension FeedUIIntegrationTests {
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }
    
    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadErrorMessage
    }
    
    var feedTitle: String {
        FeedPresenter.title
    }
}

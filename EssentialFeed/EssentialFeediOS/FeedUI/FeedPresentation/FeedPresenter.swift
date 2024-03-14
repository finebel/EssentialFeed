//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 13.03.24.
//

import EssentialFeed

protocol FeedLoadingView {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var loadingView: FeedLoadingView?
    var feedView: FeedView?
        
    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load() { [weak self] result in
            guard let self else { return }
            if let feed = try? result.get() {
                feedView?.display(feed: feed)
            }
            loadingView?.display(isLoading: false)
        }
    }
}

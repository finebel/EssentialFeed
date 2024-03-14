//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 13.03.24.
//

import EssentialFeed

struct FeedLoadingViewModel {
    let isLoading: Bool
}
protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}
protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter {
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var loadingView: FeedLoadingView?
    var feedView: FeedView?
        
    func loadFeed() {
        loadingView?.display(FeedLoadingViewModel(isLoading: true))
        feedLoader.load() { [weak self] result in
            guard let self else { return }
            if let feed = try? result.get() {
                feedView?.display(FeedViewModel(feed: feed))
            }
            loadingView?.display(FeedLoadingViewModel(isLoading: false))
        }
    }
}

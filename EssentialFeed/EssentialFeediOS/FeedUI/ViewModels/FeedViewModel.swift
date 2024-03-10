//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 10.03.24.
//

import Foundation
import EssentialFeed

final class FeedViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?
        
    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load() { [weak self] result in
            guard let self else { return }
            if let feed = try? result.get() {
                onFeedLoad?(feed)
            }
            onLoadingStateChange?(false)
        }
    }
}

//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 09.03.24.
//

import Foundation
import EssentialFeed

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let feedViewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(viewModel: feedViewModel)
        let feedController = FeedViewController(refreshController: refreshController)
        feedViewModel.onFeedLoad = adaptFeedToCellControllers(forwadingTo: feedController, loader: imageLoader)
        
        return feedController
    }
    
    private static func adaptFeedToCellControllers(forwadingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        { [weak controller] feed in
            controller?.tableModel = feed.map {
                FeedImageCellController(model: $0, imageLoader: loader)
            }
        }
    }
}

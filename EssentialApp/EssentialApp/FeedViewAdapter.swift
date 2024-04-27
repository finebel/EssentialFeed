//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 21.03.24.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    init(controller: FeedViewController, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(
            viewModel.feed.map {
                let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: $0, imageLoader: imageLoader)
                let view = FeedImageCellController(delegate: adapter)
                
                adapter.presenter = FeedImagePresenter(
                    view: WeakRefVirtualProxy(view),
                    imageTransformer: UIImage.init
                )
                
                return view
            }
        )
    }
}

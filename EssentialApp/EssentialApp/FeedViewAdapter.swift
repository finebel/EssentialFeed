//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 21.03.24.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private let selection: (FeedImage) -> Void
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<FeedImageCellController>>
    private typealias LoadMorePresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>
    
    init(
        controller: ListViewController,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void
    ) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: Paginated<FeedImage>) {
        let feedSection: [CellController] = viewModel.items.map { model in
            let adapter = ImageDataPresentationAdapter(
                loader: { [imageLoader] in
                    imageLoader(model.url)
                }
            )
            let view = FeedImageCellController(
                viewModel: FeedImagePresenter.map(model),
                delegate: adapter,
                selection: { [selection] in
                    selection(model)
                }
            )
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(view),
                loadingView: WeakRefVirtualProxy(view),
                errorView: WeakRefVirtualProxy(view),
                mapper: UIImage.tryMake
            )
            
            return CellController(id: model,view)
        }
        
        guard let loadMorePublisher = viewModel.loadMorePublisher else {
            controller?.display(feedSection)
            return
        }
        
        let loadMoreAdapter = LoadMorePresentationAdapter(loader: loadMorePublisher)
        
        let loadMoreController = LoadMoreCellController(callback: loadMoreAdapter.loadResource)
        
        loadMoreAdapter.presenter = LoadResourcePresenter(
            resourceView: self,
            loadingView: WeakRefVirtualProxy(loadMoreController),
            errorView: WeakRefVirtualProxy(loadMoreController),
            mapper: { $0 }
        )
        
        let loadMoreSection = [CellController(id: UUID(), loadMoreController)]
        
        controller?.display(feedSection, loadMoreSection)
    }
}

extension UIImage {
    struct InvalidImageData: Error {}
    
    static func tryMake(_ data: Data) throws -> UIImage {
        guard let image = UIImage.init(data: data) else { throw InvalidImageData() }
        return image
    }
}

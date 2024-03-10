//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 09.03.24.
//

import UIKit

public final class FeedRefreshViewController: NSObject {
    public lazy var view = binded(UIRefreshControl())
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
    
    public func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            if isLoading {
                view?.beginRefreshing()
            } else {
                view?.endRefreshing()
            }
        }
        
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}

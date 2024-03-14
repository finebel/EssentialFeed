//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 09.03.24.
//

import UIKit

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    public lazy var view = loadView(UIRefreshControl())
        
    private let presenter: FeedPresenter
    
    init(presenter: FeedPresenter) {
        self.presenter = presenter
    }
    
    @objc func refresh() {
        presenter.loadFeed()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    public func loadView(_ view: UIRefreshControl) -> UIRefreshControl {
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}

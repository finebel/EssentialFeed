//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 02.03.24.
//

import UIKit
import EssentialFeed

public final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    
    private var viewAppeared = false
    
    convenience public init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
    }
    
    override public func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        guard !viewAppeared else { return }
        viewAppeared = true
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load() { [weak self] _ in
            guard let self else { return }
            refreshControl?.endRefreshing()
        }
    }
}

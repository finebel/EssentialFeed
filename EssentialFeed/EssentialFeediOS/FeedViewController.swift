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
    private var tableModel: [FeedImage] = []
    
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
        loader?.load() { [weak self] result in
            guard let self else { return }
            tableModel = (try? result.get()) ?? []
            
            tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = (cellModel.location == nil)
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        
        return cell
    }
}
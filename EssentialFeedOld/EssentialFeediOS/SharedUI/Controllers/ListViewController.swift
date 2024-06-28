//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 02.03.24.
//

import UIKit
import EssentialFeed

public final class ListViewController: UITableViewController, ResourceLoadingView, ResourceErrorView {
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, cellController in
            cellController.dataSource.tableView(tableView, cellForRowAt: indexPath)
        }
    }()
    
    private var viewAppeared = false
    public var onRefresh: (() -> Void)?
    private(set) public var errorView = ErrorView(frame: .zero)
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.sizeTableHeaderToFit()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override public func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        guard !viewAppeared else { return }
        viewAppeared = true
        refresh()
    }
    
    @IBAction private func refresh() {
        onRefresh?()
    }
    
    private func configureTableView() {
        tableView.tableHeaderView = errorView.wrapInContainer()
        tableView.dataSource = dataSource
        
        errorView.onHide = { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.sizeTableHeaderToFit()
            self?.tableView.endUpdates()
        }
    }
    
    public func display(_ sections: [CellController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        sections.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems(cellControllers, toSection: section)
        }
        
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        errorView.message = viewModel.message
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellController = cellController(at: indexPath)
        cellController?.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellController = cellController(at: indexPath)
        cellController?.delegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let controller = cellController(at: indexPath)
        controller?.delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }

    private func cellController(at indexPath: IndexPath) -> CellController? {
        dataSource.itemIdentifier(for: indexPath)
    }
}

extension ListViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let controller = cellController(at: indexPath)
            controller?.dataSourcePrefetching?.tableView(tableView, prefetchRowsAt: [indexPath])
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let controller = cellController(at: indexPath)
            controller?.dataSourcePrefetching?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
        }
    }
}

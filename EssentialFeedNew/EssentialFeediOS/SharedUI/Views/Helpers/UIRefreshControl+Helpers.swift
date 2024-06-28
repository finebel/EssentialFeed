//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 29.03.24.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}

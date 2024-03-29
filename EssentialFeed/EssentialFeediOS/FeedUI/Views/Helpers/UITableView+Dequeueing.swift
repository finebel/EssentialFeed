//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 16.03.24.
//

import UIKit

extension UITableView {
    /// **Warning**: This method expects the cell to have it's class name set as the `reuseIdentifier`
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}

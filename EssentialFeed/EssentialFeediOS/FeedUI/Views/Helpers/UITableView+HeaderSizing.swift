//
//  UITableView+HeaderSizing.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 17.04.24.
//

import UIKit

extension UITableView {
    func sizeTableHeaderToFit() {
        guard let header = tableHeaderView else { return }
        
        let targetSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let needsFrameUpdate = header.frame.height != targetSize.height
        if needsFrameUpdate {
            header.frame.size.height = targetSize.height
            tableHeaderView = header
        }
    }
}

//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Finn Ebeling on 18.04.24.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}

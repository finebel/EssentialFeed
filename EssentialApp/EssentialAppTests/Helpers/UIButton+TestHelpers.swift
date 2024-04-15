//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Finn Ebeling on 08.03.24.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}

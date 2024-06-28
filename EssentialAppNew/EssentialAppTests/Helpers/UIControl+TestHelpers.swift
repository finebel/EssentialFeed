//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Finn Ebeling on 08.03.24.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach { action in
                (target as NSObject).perform(Selector(action))
            }
        }
    }
}

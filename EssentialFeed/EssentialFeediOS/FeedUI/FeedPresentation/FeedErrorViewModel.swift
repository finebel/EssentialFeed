//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 29.03.24.
//

import Foundation

struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        Self(message: nil)
    }
    
    static func error(message: String) -> Self {
        Self(message: message)
    }
}

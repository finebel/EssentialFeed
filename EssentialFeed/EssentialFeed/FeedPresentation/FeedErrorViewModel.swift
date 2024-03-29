//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 29.03.24.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        Self(message: nil)
    }
    
    static func error(message: String) -> Self {
        Self(message: message)
    }
}

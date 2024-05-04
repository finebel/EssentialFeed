//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 30.03.24.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?

    public var hasLocation: Bool {
        location != nil
    }
}

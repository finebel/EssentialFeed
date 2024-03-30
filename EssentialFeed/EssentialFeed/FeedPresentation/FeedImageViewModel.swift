//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 30.03.24.
//

import Foundation

public struct FeedImageViewModel<Image> {
    public let description: String?
    public let location: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
    public var hasLocation: Bool {
        location != nil
    }
}

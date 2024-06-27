//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 30.03.24.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location
        )
    }
}

//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 29.03.24.
//

import Foundation

public final class FeedPresenter {
    public static var title: String {
        NSLocalizedString(
            "FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: Self.self),
            comment: "Title for the feed view"
        )
    }
    
    // TODO: - Currently, we don't use this method in production. So it might be deleted.
    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}

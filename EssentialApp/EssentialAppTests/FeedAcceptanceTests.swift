//
//  FeedAcceptanceTests.swift
//  EssentialAppTests
//
//  Created by Finn Ebeling on 15.04.24.
//

import XCTest
import EssentialFeed
import EssentialFeediOS
@testable import EssentialApp

final class FeedAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() throws {
        let feed = try launch(httpClient: .online(response), store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertTrue(feed.canLoadMoreFeed)
        
        feed.simulateLoadMoreFeedAction()
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertEqual(feed.renderedFeedImageData(at: 2), makeImageData2())
        XCTAssertTrue(feed.canLoadMoreFeed)
        
        feed.simulateLoadMoreFeedAction()
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertEqual(feed.renderedFeedImageData(at: 2), makeImageData2())
        XCTAssertFalse(feed.canLoadMoreFeed, "Shouldn't be able to load more, since we have reached the end")
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() throws {
        let sharedStore = try CoreDataFeedStore.empty
        let onlineFeed = launch(httpClient: .online(response), store: sharedStore)
        
        onlineFeed.simulateFeedImageViewVisible(at: 0)
        onlineFeed.simulateFeedImageViewVisible(at: 1)
        onlineFeed.simulateLoadMoreFeedAction()
        onlineFeed.simulateFeedImageViewVisible(at: 2)
        
        let offlineFeed = launch(httpClient: .offline, store: sharedStore)
        
        XCTAssertEqual(offlineFeed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 2), makeImageData2())
    }
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() throws {
        let feed = try launch(httpClient: .offline, store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 0)
    }
    
    func test_onEnteringBackground_deletesExpiredFeedCache() throws {
        let store = try CoreDataFeedStore.withExpiredFeedCache
        
        enterBackground(with: store)
        
        XCTAssertNil(try store.retrieve(), "Expected to delete expired cache")
    }
    
    func test_onEnteringBackground_keepsNonExpiredFeedCache() throws {
        let store = try CoreDataFeedStore.withNonExpiredFeedCache
        
        enterBackground(with: store)
        
        XCTAssertNotNil(try store.retrieve(), "Expected to keep non-expired cache")
    }
    
    func test_onFeedImageSelection_displaysComments() throws {
        let comments = try showCommentsForFirstImage()
        
        XCTAssertEqual(comments.numberOfRenderedComments(), 1)
        XCTAssertEqual(comments.commentMessage(at: 0), self.makeCommentMessage())
    }
    
    // MARK: - Helpers
    
    private func launch(
        httpClient: HTTPClientStub = .offline,
        store: CoreDataFeedStore
    ) -> ListViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store)
        sut.window = UIWindow()
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        let vc = nav?.topViewController as! ListViewController
        vc.simulateAppearance()
        return vc
    }
    
    private func enterBackground(with store: CoreDataFeedStore) {
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline, store: store)
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
    }
        
    private func showCommentsForFirstImage() throws -> ListViewController{
        let feed = try launch(httpClient: .online(response), store: .empty)
        
        feed.simulateTapOnFeedImage(at: 0)
        RunLoop.current.run(until: Date()) // avoid issues due to performed animations
        
        let nav = feed.navigationController
        let commentsVC = nav?.topViewController as! ListViewController
        commentsVC.simulateAppearance()
        return commentsVC
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }

    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "/image-0":
            return makeImageData0()
            
        case "/image-1":
            return makeImageData1()
        
        case "/image-2":
            return makeImageData2()

        case "/essential-feed/v1/feed" where url.query()?.contains("after_id") == false:
            return makeFirstFeedPageData()
        
        case "/essential-feed/v1/feed" where url.query()?.contains("after_id=B2D1FA4B-17B2-4790-B831-98FE133910DE") == true:
            return makeSecondFeedPageData()
        
        case "/essential-feed/v1/feed" where url.query()?.contains("after_id=6BB53B9D-09E1-4309-99B2-BF17FD903DC2") == true:
            return makeLastEmptyFeedPageData()
            
        case "/essential-feed/v1/image/CB7721A7-22C8-4EFE-A013-8AABF2326A12/comments":
            return makeCommentsData()
            
        default:
            return Data()
        }
    }

    private func makeImageData0() -> Data { UIImage.make(withColor: .red).pngData()! }
    private func makeImageData1() -> Data { UIImage.make(withColor: .green).pngData()! }
    private func makeImageData2() -> Data { UIImage.make(withColor: .blue).pngData()! }

    private func makeFirstFeedPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": "CB7721A7-22C8-4EFE-A013-8AABF2326A12", "image": "http://feed.com/image-0"],
            ["id": "B2D1FA4B-17B2-4790-B831-98FE133910DE", "image": "http://feed.com/image-1"]
        ]])
    }
    
    private func makeSecondFeedPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": "6BB53B9D-09E1-4309-99B2-BF17FD903DC2", "image": "http://feed.com/image-2"]
        ]])
    }
    
    private func makeLastEmptyFeedPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": []])
    }
    
    private func makeCommentsData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            [
                "id": UUID().uuidString,
                "message": makeCommentMessage(),
                "created_at": "2020-05-20T11:24:59+0000",
                "author": [
                    "username": "a username"
                ]
            ]
        ]])
    }
    
    private func makeCommentMessage() -> String {
        "a message"
    }
}

extension CoreDataFeedStore {
    static var empty: CoreDataFeedStore {
        get throws {
            try CoreDataFeedStore(storeURL: URL(fileURLWithPath: "/dev/null"), contextQueue: .main)
        }
    }
    
    static var withExpiredFeedCache: CoreDataFeedStore {
        get throws {
            let store = try CoreDataFeedStore.empty
            try store.insert([], timestamp: .distantPast)
            return store
        }
    }
    
    static var withNonExpiredFeedCache: CoreDataFeedStore {
        get throws {
            let store = try CoreDataFeedStore.empty
            try store.insert([], timestamp: .now)
            return store
        }
    }
}

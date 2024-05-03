//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Finn Ebeling on 17.03.24.
//

import XCTest
import EssentialFeed

final class FeedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}

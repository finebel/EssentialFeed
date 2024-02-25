//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Finn Ebeling on 19.02.24.
//

import EssentialFeed
import XCTest

extension FailableDeleteFeedStoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected deletion to fail since store URL is invalid", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.empty), file: file, line: line)
        
    }
}

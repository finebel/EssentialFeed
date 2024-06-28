//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 08.03.24.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}

//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 05.02.24.
//

import Foundation

public typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    /// - Parameter completion: Can be invoked in any thread. Clients are responsible to dispatch to appropriate threads, if needed.
    func get(fromURL url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 07.02.24.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentationError: Error {}
    
    public func get(fromURL url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        let dataTask = session.dataTask(with: url) { data, response, error in
            let result: HTTPClient.Result = Result {
                if let error {
                    throw error
                } else if let data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentationError()
                }
            }
            completion(result)
        }
        dataTask.resume()
    }
}

//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 10.03.24.
//

import Foundation

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        location != nil
    }
}

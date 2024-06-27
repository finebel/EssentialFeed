//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 29.03.24.
//

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?
    
    static var noError: ResourceErrorViewModel {
        Self(message: nil)
    }
    
    static func error(message: String) -> Self {
        Self(message: message)
    }
}

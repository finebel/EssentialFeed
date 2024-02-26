//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 11.02.24.
//

import Foundation

enum FeedCachePolicy {
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static let maxCacheAgeInDays = 7
    
    static func validate(_ timestamp: Date, against currentDate: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: -maxCacheAgeInDays, to: currentDate) else { return false }
        
        return timestamp > maxCacheAge
    }
}

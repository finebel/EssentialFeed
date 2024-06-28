//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Finn Ebeling on 02.04.24.
//

import Foundation

extension HTTPURLResponse {
    private static let OK_200: Int = 200
    
    var isOK: Bool {
        statusCode == Self.OK_200
    }
}

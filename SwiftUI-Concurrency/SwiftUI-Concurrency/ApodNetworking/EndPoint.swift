//
//  EndPoint.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/10.
//

import Foundation

public protocol EndPoint {
    var base: String { get }
    var path: String { get }
    var fullPath: String { get }
}

public extension EndPoint {
    var fullPath: String {
        return base + path
    }
}

public enum ApodEndPoint: EndPoint {
    case apod
    
    public var base: String {
        return "https://api.nasa.gov"
    }
    
    public var path: String {
        switch self {
        case .apod:
            return "/planetary/apod"
        }
    }
}

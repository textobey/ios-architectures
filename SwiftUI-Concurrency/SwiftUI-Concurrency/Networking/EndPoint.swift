//
//  EndPoint.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/24.
//

import Foundation

protocol EndPoint {
    var base: String { get }
    var path: String { get }
    var fullPath: String { get }
}

extension EndPoint {
    var fullPath: String {
        return base + path
    }
}

enum BookAPI: EndPoint {
    case book
    case detail(String)
    case search(String, Int)
    
    var base: String {
        return "https://api.itbook.store/1.0"
    }
    
    var path: String {
        switch self {
        case .book:
            return "/new"
        case .detail(let isbn13):
            return "/1.0/books/\(isbn13)"
        case .search(let word, let page):
            return "/1.0/search/\(word)/\(page)"
        }
    }
}

//
//  BookAPI.swift
//  SwiftUI-MV-Concurrency
//
//  Created by 이서준 on 2023/08/29.
//

import Foundation

protocol EndPoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension EndPoint {
    var headers: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    var url: URL? {
        var components = URLComponents(string: base)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
}

enum BookAPI: EndPoint {
    case book
    case detail(String)
    case search(String, Int)
    
    var base: String {
        return "https://api.itbook.store"
    }
    
    var path: String {
        switch self {
        case .book:
            return "/1.0/new"
        case .detail(let isbn13):
            return "/1.0/books/\(isbn13)"
        case .search(let word, let page):
            return "/1.0/search/\(word)/\(page)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
}

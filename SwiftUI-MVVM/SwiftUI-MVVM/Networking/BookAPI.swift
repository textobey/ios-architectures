//
//  BookAPI.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/11/23.
//

import Foundation

protocol APIRequestType {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

enum BookAPI {
    case new
    case search(String, String)
    case detail(String)
}

extension BookAPI: APIRequestType {
    var path: String {
        switch self {
        case .new:
            return "/1.0/new"
        case .search(let word, let page):
            return "/1.0/search/\(word)/\(page)"
        case .detail(let isbn13):
            return "/1.0/books/\(isbn13)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
}

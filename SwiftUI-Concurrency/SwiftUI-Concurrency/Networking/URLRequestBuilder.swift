//
//  URLRequestBuilder.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/24.
//

import Foundation

protocol URLParameter {
    var key: String { get }
    var value: String { get }
}

enum BookParameter: URLParameter {
    case new
    case detail(String)
    case search(String, Int)
    
    // 사용X, parameter(body) 없이 path만으로 response 수신 가능
    var key: String {
        switch self {
        case .new:
            return "/new"
        case .detail:
            return "/1.0/books/"
        case .search:
            return "/1.0/search/"
        }
    }
    
    var value: String {
        switch self {
        case .new:
            return ""
        case .detail(let isbn13):
            return "\(isbn13)"
        case .search(let word, let page):
            return "\(word)/\(page)"
        }
    }
}

protocol URLBuilder {
    func build(endPoint: EndPoint, parameters: [URLParameter]) throws -> URL
}

enum URLBuilderError: Error {
    case invalidFullPath
    case invalidURL
}

struct DefaultURLBuilder: URLBuilder {
    func build(endPoint: EndPoint, parameters: [URLParameter]) throws -> URL {
        guard let urlComponents = URLComponents(string: endPoint.fullPath) else {
            throw URLBuilderError.invalidFullPath
        }
        
        guard let url = urlComponents.url else {
            throw URLBuilderError.invalidURL
        }
        
        return url
    }
}

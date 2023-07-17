//
//  URLRequestBuilder.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/10.
//

import Foundation

// TODO: URLQueryItem 조사
public protocol URLParameter {
    var name: String { get }
    var value: String { get }
    
    func buildQueryItem() -> URLQueryItem
}

public enum APodParameter: URLParameter {
    
    case apiKey
    case count(String)
    case startDate(Date)
    case endDate(Date)
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }
    
    public var name: String {
        switch self {
        case .apiKey:
            return "api_key"
        case .count:
            return "count"
        case .startDate:
            return "start_date"
        case .endDate:
            return "end_date"
        }
    }
    
    public var value: String {
        switch self {
        case .apiKey:
            return "E0KqAaJyQaf8wdkbq5BaPcc5mP8gfVgN6GsGQ5ma"
        case .count(let value):
            return value
        case .startDate(let date):
            return dateFormatter.string(from: date)
        case .endDate(let date):
            return dateFormatter.string(from: date)
        }
    }
    
    public func buildQueryItem() -> URLQueryItem {
        URLQueryItem(name: name, value: value)
    }
}

public protocol URLBuilder {
    func build(endPoint: EndPoint, parameters: [URLParameter]) throws -> URL
}

enum URLBuilderError: Error {
    case invalidFullPath
    case invalidURL
}

public struct DefaultURLBuilder: URLBuilder {
    public func build(endPoint: EndPoint, parameters: [URLParameter]) throws -> URL {
        guard var urlComponents = URLComponents(string: endPoint.fullPath) else {
            throw URLBuilderError.invalidFullPath
        }
        let queryItems = parameters.map { $0.buildQueryItem() }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw URLBuilderError.invalidURL
        }
        
        return url
    }
}

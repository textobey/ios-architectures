//
//  BookEndPoint.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/12/23.
//

import Foundation

protocol EndPointType {
    associatedtype API: APIRequestType
    
    var baseURL: String { get }
    var api: API { get }
}

extension EndPointType {
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = api.path
        components?.queryItems = api.queryItems
        return components?.url
    }
}

struct BookEndPoint: EndPointType {
    typealias API = BookAPI
    
    let baseURL: String
    let api: API
    
    init(
        baseURL: String = "https://api.itbook.store",
        api: BookAPI
    ) {
        self.baseURL = baseURL
        self.api = api
    }
}

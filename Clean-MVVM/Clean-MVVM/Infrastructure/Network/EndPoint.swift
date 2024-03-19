//
//  EndPoint.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/19/24.
//

import Foundation

enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

class EndPoint {
    let path: String
    let method: HTTPMethodType
    
    init(
        path: String,
        method: HTTPMethodType)
    {
        self.path = path
        self.method = method
    }
}

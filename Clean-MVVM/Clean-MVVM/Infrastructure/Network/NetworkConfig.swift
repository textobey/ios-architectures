//
//  NetworkConfig.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/19/24.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

struct BookAPINetworkConfig: NetworkConfigurable {
    let baseURL: URL
    let headers: [String : String]
    let queryParameters: [String : String]
    
    init(baseURL: URL, headers: [String : String], queryParameters: [String : String]) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}

//
//  BaseAPI.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/12.
//

import Foundation
import Moya

protocol BaseAPI: TargetType { }

extension BaseAPI {
    var baseURL: URL {
        guard let url = URL(string: "https://api.itbook.store") else { fatalError("Not found baseUrl") }
        return url
    }
    
    var headers: [String: String]? {
        ["Content-Type":"application/json"]
    }
}

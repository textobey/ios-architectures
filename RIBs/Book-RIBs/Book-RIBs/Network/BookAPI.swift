//
//  BookAPI.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/12.
//

import Foundation
import Moya

enum BookAPI {
    case new
    case detail(isbn13: String)
    case search(word: String, page: Int)
}

extension BookAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .new:
            return "/1.0/new"
        case .detail(let isbn13):
            return "/1.0/books/\(isbn13)"
        case .search(let word, let page):
            return "/1.0/search/\(word)/\(page)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .new, .search, .detail:
            return .requestPlain
        //case .search, .detail:
        //    return .requestParameters(
        //        parameters: parameters,
        //        encoding: URLEncoding.queryString
        //    )
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    //var parameters: [String: Any]? {
    //    switch self {
    //    case .detail(let isbn13):
    //        return [
    //            "isbn13": isbn13
    //        ]
    //    case .search(let word, let page):
    //        return [
    //            "word": word,
    //            "page": page
    //        ]
    //    default:
    //        return [:]
    //    }
    //}
}

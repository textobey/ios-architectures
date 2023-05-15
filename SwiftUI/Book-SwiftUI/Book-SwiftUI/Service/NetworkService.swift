//
//  NetworkService.swift
//  Book-SwiftUI
//
//  Created by 이서준 on 2023/05/15.
//

import Foundation
import Combine

enum BookAPI {
    case new
    case detail(isbn13: String)
    case search(word: String, page: Int)
    
    var endPoint: URL {
        let url = "https://api.itbook.store"
        switch self {
        case .new:
            return URL(string: url + "/1.0/new")!
        case .detail(let isbn13):
            return URL(string: url + "/1.0/books/\(isbn13)")!
        case .search(let word, let page):
            return URL(string: url + "/1.0/search/\(word)/\(page)")!
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type":"application/json"]
    }
}

final class NetworkService {
    
    static let `shared` = NetworkService()
    
    private let urlSession = URLSession.shared
    
    private var baseURL: URL {
        guard let url = URL(string: "https://api.itbook.store") else { fatalError("Not found baseUrl") }
        return url
    }
    
    private var headers: [String: String]? {
        ["Content-Type":"application/json"]
    }
    
    func request(_ api: BookAPI, completion: @escaping (Result<BookModel, Error>) -> Void) {
        let task = urlSession.dataTask(with: api.endPoint) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let bookModel = try JSONDecoder().decode(BookModel.self, from: data!)
                completion(.success(bookModel))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

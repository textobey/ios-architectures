//
//  NetworkService.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class NetworkService {
    // MARK: - Properties
    static let shared: NetworkService = NetworkService()
    
    static var headers: HTTPHeaders {
        ["Content-Type":"application/json"]
    }
}

extension NetworkService {
    private func fetchRequestEndPoint(_ path: String, _ query1: String?, _ query2: String?) -> URL? {
        let baseURL = "https://api.itbook.store"
        var urlComponent = URLComponents(string: baseURL)
        
        switch path {
        case "search":
            urlComponent?.path = "/1.0/\(path)/\(query1!)/\(query2!)"
        case "books":
            urlComponent?.path = "/1.0/\(path)/\(query1!)"
        default:
            urlComponent?.path = "/1.0/\(path)"
        }
        // error handligin 만들기 -> alert 만들고 return
        return urlComponent?.url
    }
}

extension NetworkService {
    func fetchBookItems() -> ReturnResult<BookModel, Error> {
        let url = BooksURL.new.rawValue
        return request(url: URL(string: url)!, type: BookModel.self)
    }
    
    func fetchBookDetail(of isbn13: String) -> ReturnResult<BookModel, Error> {
        let url = fetchRequestEndPoint("books", isbn13, nil)
        return request(url: url!, type: BookModel.self)
    }
    
    func fetchSearchResults(of word: String, page: Int = 1) -> ReturnResult<BookModel, Error> {
        let url = fetchRequestEndPoint("search", word, String(page))
        return request(url: url!, type: BookModel.self)
    }
    
    private func request<T: Decodable>(url: URL, type: T.Type) -> ReturnResult<T, Error> {
        return ReturnResult<T, Error> { promise in
            AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Self.headers)
                .validate(statusCode: 200 ..< 300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let response):
                        promise(.success(response))
                        return
                    case .failure(let error):
                        promise(.failure(error))
                        return
                    }
                }
        }
    }
}

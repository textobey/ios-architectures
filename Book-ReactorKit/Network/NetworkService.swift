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
    
    private var headers: HTTPHeaders {
        ["Content-Type":"application/json"]
    }
    
    //let booksRelay = BehaviorRelay<[BookItem]>(value: [])
    //var disposeBag = DisposeBag()
    //var url: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
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
    func fetchBookItems(completionHandler: @escaping (Result<[BookItem], Error>) -> Void) {
        let url = BooksURL.new.rawValue
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: BookModel.self) { response in
                switch response.result {
                case .success(let response):
                    completionHandler(.success(response.books ?? []))
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(.failure(error))
                }
            }
    }
}


//
//    func loadData(completionHandler: @escaping (BookModel) -> Void) {
//
//        guard let url = URL(string: self.url.value) else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            // client-side error
//            guard error == nil else { return }
//
//            // server-side error
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
//            let successRange = 200..<300
//            guard successRange.contains(statusCode) else {
//                // alertview 띄우기
//                print("statusCode: \(statusCode)")
//                return
//            }
//            do {
//                guard let _data = data else { return }
//
//                let entity = try JSONDecoder().decode(BookModel.self, from: _data)
//
//                completionHandler(entity)
//
//            } catch let error {
//                print("error: \(error.localizedDescription)")
//                // FIXME: - alert view
//            }
//        }.resume()
//    }
//
//    func fetchBooks(completionHandler: @escaping ([BookItem]) -> Void) {
//        self.loadData { entity in
//            guard let books = entity.books else { return }
//            completionHandler(books)
//        }
//    }
//
//    func loadBooksData(path: String, query1: String?, query2: String?) {
//
//        let requestURL = self.configuraURL(path, query1, query2)
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: requestURL!)) { data, response, error in
//
//            guard error == nil else {
//                return
//            }
//            do {
//                guard let _data = data else { return }
//
//                let bookModel = try JSONDecoder().decode(BookModel.self, from: _data)
//
//                guard let books = bookModel.books else { return }
//
//                self.booksRelay.accept(books)
//
//                print("~~~> books: \(books)")
//
//            } catch let error {
//                print("error: \(error.localizedDescription)")
//            }
//        }
//        task.resume()
//    }
//
//    // MARK: 데이터 로드 함수 -> New
//    func loadData(path: String, query1: String?, query2: String?) -> Observable<BookModel> {
//
//        return Observable.create { emitter in
//
//            let requestURL = self.configuraURL(path, query1, query2)
//
//            let task = URLSession.shared.dataTask(with: URLRequest(url: requestURL!)) { data, response, error in
//
//                guard error == nil else {
//                    emitter.onError(error!)
//                    return
//                }
//                do {
//                    guard let _data = data else { return }
//
//                    let bookModel = try JSONDecoder().decode(BookModel.self, from: _data)
//
//                    emitter.onNext(bookModel)
//
//                    emitter.onCompleted()
//
//                } catch let error {
//                    print("error: \(error.localizedDescription)")
//                }
//            }
//            task.resume()
//
//            return Disposables.create {
//                task.cancel()
//            }
//        }
//    }
//
//    // MARK: 데이터 로드 함수 ->  Search / Detail
//    func loadData(path: String, query1: String?, query2: String?, completionHandler: @escaping (BookModel) -> Void) {
//
//        guard let requestURL = self.configuraURL(path, query1, query2) else { return }
//
//        URLSession.shared.dataTask(with: requestURL) { data, response, error in
//            // client-side error
//            guard error == nil else { return }
//
//            // server-side error
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
//            let successRange = 200..<300
//            guard successRange.contains(statusCode) else {
//                // alertview 띄우기
//                print("statusCode: \(statusCode)")
//                completionHandler(BookModel())
//                return
//            }
//            do {
//                guard let _data = data else {
//                    completionHandler(BookModel())
//                    return
//                }
//                let bookModel = try JSONDecoder().decode(BookModel.self, from: _data)
//
//                completionHandler(bookModel)
//
//            } catch let error {
//                print("error: \(error.localizedDescription)")
//                // FIXME: - alert view
//                completionHandler(BookModel())
//            }
//        }.resume()
//    }
//}
//
//// MARK: - Methods
///// url 생성 함수
//func configuraURL(_ path: String, _ query1: String?, _ query2: String?) -> URL? {
//    let baseURL = "https://api.itbook.store"
//
//    var urlComponent = URLComponents(string: baseURL)
//
//    switch path {
//        case "search":
//            urlComponent?.path = "/1.0/\(path)/\(query1!)/\(query2!)"
//        case "books":
//            urlComponent?.path = "/1.0/\(path)/\(query1!)"
//        default:
//            urlComponent?.path = "/1.0/\(path)"
//    }
//    // error handligin 만들기 -> alert 만들고 return
//
//    return urlComponent?.url
//}

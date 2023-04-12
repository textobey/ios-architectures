//
//  NetworkImpl.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/12.
//

import Foundation
import Moya
import RxMoya
import RxSwift

final class NetworkImpl: Network {
    
    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<BookAPI>()
    
    func request<T: Decodable>(
        _ api: BookAPI,
        file: StaticString,
        function: StaticString,
        line: UInt
    ) -> ReturnResult<T, Error> {
        return ReturnResult<T, Error> { [weak self] promise in
            self?.provider.request(api) { response in
                switch response {
                case .success(let result):
                    guard let data = try? result.map(T.self) else { return }
                    promise(.success(data))
                    return
                case .failure(let error):
                    promise(.failure(error))
                    return
                }
            }
        }
    }
}

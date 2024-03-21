//
//  DataTransferService.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/21/24.
//

import Foundation
import Combine

enum DataTransferError: Error {
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

protocol DataTransferService {
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(
        endPoint: E
    ) -> AnyPublisher<T, DataTransferError> where E.Response == T
}

class DefaultDataTransferService {
    
    let networkSerivce: NetworkSerivce
    
    init(networkSerivce: NetworkSerivce) {
        self.networkSerivce = networkSerivce
    }
    
}

extension DefaultDataTransferService: DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(
        endPoint: E
    ) -> AnyPublisher<T, DataTransferError> where E.Response == T {
        networkSerivce.request(endPoint: endPoint)
            .tryMap { data -> T in
                do {
                    let result: T = try endPoint.responseDecoder.decode(T.self, from: data)
                    return result
                } catch {
                    throw DataTransferError.parsing(error)
                }
            }
            .mapError { error in
                return error is NetworkError
                ? .networkFailure(error as! NetworkError)
                : .resolvedNetworkFailure(error)
            }
            .eraseToAnyPublisher()
    }
}

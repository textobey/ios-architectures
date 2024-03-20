//
//  NetworkSerivce.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/14/24.
//

import Foundation
import Combine

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

protocol NetworkSerivce {
    typealias CompletionHandler = (Result<Data?, Error>) -> Void
    
    func request(endPoint: Requestable) -> AnyPublisher<Data, Error>
}

final class DefaultNetworkSerivce {
    
    private let config: NetworkConfigurable
    
    init(config: NetworkConfigurable) {
        self.config = config
    }
    
    private func request(request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error in
                let code = URLError.Code(rawValue: (error as NSError).code)
                switch code {
                case .notConnectedToInternet: return NetworkError.notConnected
                case .cancelled: return NetworkError.cancelled
                default: return NetworkError.generic(error)
                }
            }
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw NetworkError.generic(URLError(.badServerResponse))
                }
                if (200 ..< 300).contains(httpResponse.statusCode) {
                    return element.data
                }
                throw NetworkError.error(statusCode: httpResponse.statusCode, data: element.data)
            }
            .eraseToAnyPublisher()
    }
}

extension DefaultNetworkSerivce: NetworkSerivce {
    func request(endPoint: Requestable) -> AnyPublisher<Data, Error> {
        do {
            let urlRequest = try endPoint.urlRequest(with: config)
            return request(request: urlRequest)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

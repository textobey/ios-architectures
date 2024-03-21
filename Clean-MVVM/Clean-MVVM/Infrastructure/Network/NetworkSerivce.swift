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
    func request(endPoint: Requestable) -> AnyPublisher<Data, NetworkError>
}

final class DefaultNetworkSerivce {
    
    private let config: NetworkConfigurable
    
    init(config: NetworkConfigurable) {
        self.config = config
    }
    
    // 흥미로운 다른 관점.
    // network request 구현부에서 에러 핸들링, 디코딩(혹은 인코딩)을 포함하여 작업했지만,
    // 여기서는 request 레벨에만 맞는 작업을 수행하고, 디코딩(혹은 인코딩)작업은 DataTransferService의 역할
    private func request(request: URLRequest) -> AnyPublisher<Data, NetworkError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw NetworkError.generic(URLError(.badServerResponse))
                }
                if (200 ..< 300).contains(httpResponse.statusCode) {
                    return element.data
                }
                throw NetworkError.error(statusCode: httpResponse.statusCode, data: element.data)
            }
            .mapError { error in
                let code = URLError.Code(rawValue: (error as NSError).code)
                switch code {
                case .notConnectedToInternet: return NetworkError.notConnected
                case .cancelled: return NetworkError.cancelled
                default: return NetworkError.generic(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

extension DefaultNetworkSerivce: NetworkSerivce {
    func request(endPoint: Requestable) -> AnyPublisher<Data, NetworkError> {
        do {
            let urlRequest = try endPoint.urlRequest(with: config)
            return request(request: urlRequest)
        } catch {
            return Fail(error: NetworkError.urlGeneration)
                .eraseToAnyPublisher()
        }
    }
}

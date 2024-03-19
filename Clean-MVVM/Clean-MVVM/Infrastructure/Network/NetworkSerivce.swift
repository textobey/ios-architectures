//
//  NetworkSerivce.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/14/24.
//

import Foundation
import Combine

protocol NetworkSerivce {
    typealias CompletionHandler = (Result<Data?, Error>) -> Void
    
    func request(endPoint: EndPoint) -> AnyPublisher<Data, Error>
}

final class DefaultNetworkSerivce {
    
    private let config: NetworkConfigurable
    
    init(config: NetworkConfigurable) {
        self.config = config
    }
    
    private func request(request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                return element.data
            }
            .eraseToAnyPublisher()
    }
}

extension DefaultNetworkSerivce: NetworkSerivce {
    func request(endPoint: EndPoint) -> AnyPublisher<Data, Error> { //Cancellable? {
        let baseURL = config.baseURL.absoluteString
        let uri = baseURL.appending(endPoint.path)
        
        var urlRequest = URLRequest(url: URL(string: uri)!)
        urlRequest.httpMethod = endPoint.method.rawValue
        
        return request(request: urlRequest)
    }
}

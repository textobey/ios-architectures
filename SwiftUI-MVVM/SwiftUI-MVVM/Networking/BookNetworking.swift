//
//  BookNetworking.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/11/23.
//

import Foundation
import Combine

protocol BookNetworkingType {
    // Future: RxSwift의 Single처럼 작업의 결과를 한 번만 실행되는 작업에 적합함
        // 그렇다면, Networking 모듈은 생명주기가 앱의 생명주기와 같다.
        // 이 경우에 reuqest 메서드에서 발생한 AnyCancellable의 메모리 해제는 어떻게 해야할까?
    
    // AnyPublisher: 여러번 실행될 수 있는 작업에 적합함
    func request<T: Decodable>(_ api: BookAPI)  -> Future<T, Error>
}

final class BookNetworking: BookNetworkingType {
    
    private var cancellable = Set<AnyCancellable>()
    
    func request<T: Decodable>(_ api: BookAPI) -> Future<T, Error> {
        let endPoint = BookEndPoint(api: api)
        
        return Future<T, Error> { promise in
            guard let url = endPoint.url else {
                promise(.failure(URLError(.badURL)))
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // FIXME: AnyCancellable을 cancel 처리하고, 메모리에서 해제해주는 방법
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let httpResponse = output.response as? HTTPURLResponse,
                          httpResponse.statusCode > 400 else {
                        throw URLError(.badServerResponse)
                    }
                    return output.data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            promise(.failure(error))
                        case .finished:
                            break
                        }
                    },
                    receiveValue: { value in
                        promise(.success(value))
                    }
                )
        }
    }
}

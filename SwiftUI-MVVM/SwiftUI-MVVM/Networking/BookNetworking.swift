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
        // AnyPublisher의 경우 각 단계가 체인 형태로 연결되어 있어 가독성면에서 이점이 있음
        // eraseToAnyPublisher로 인해 AnyPublisher로 반환되기 때문에, request 이후에 더 연산자 활용이 가능함
    func request<T: Decodable>(_ api: BookAPI, retryCount: Int) -> AnyPublisher<T, Error>
}

extension BookNetworkingType {
    func request<T: Decodable>(_ api: BookAPI, retryCount: Int = 0) -> AnyPublisher<T, Error> {
        return request(api, retryCount: retryCount)
    }
}

final class BookNetworking: BookNetworkingType {
    
    // TODO: 에러 발생시에 Alert을 표시하고, API Request를 다시 시도하는(fallBack?)
    private var retryTrigger = PassthroughSubject<Int, Never>()
     
    func request<T: Decodable>(_ api: BookAPI, retryCount: Int = 0) -> AnyPublisher<T, Error> {
        let endPoint = BookEndPoint(api: api)
        
        guard let url = endPoint.url else {
            return Fail(
                outputType: T.self,
                failure: URLError(.badURL)
            ).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { element in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode <= 400 else {
                    throw BookError(
                        api: api,
                        reason: BookErrorReason.badServerResponse,
                        retryCount: retryCount
                    )
                }
                let randomError = Int.random(in: 1 ... 10)
                
                if let errorReason = BookErrorReason(rawValue: randomError) {
                    throw BookError(
                        api: api,
                        reason: errorReason,
                        retryCount: retryCount
                    )
                }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { output in
                print("✅ \(#line) \(#function), API Request Response: \(output)")
            })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    /*
     
    func request<T: Decodable>(_ api: BookAPI) -> Future<T, Error> {
        let endPoint = BookEndPoint(api: api)
        
        return Future<T, Error> { promise in
            guard let url = endPoint.url else {
                promise(.failure(URLError(.badURL)))
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // Future는 한번의 이벤트 발생이후 시퀀스의 종료(생명주기의 끝)이 보장되어 있기 때문에,
            // AnyCancellable에 대한 생명주기 관리를 직접 할 필요가 없을것으로 보임
            _ = URLSession.shared.dataTaskPublisher(for: request)
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
     
     */
}

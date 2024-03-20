//
//  EndPoint.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/19/24.
//

import Foundation

enum HTTPMethodType: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// TODO: EndPoint vs URI
// EndPoint?
// EndPoint는 단순히 리소스의 위치를 나타내는 Path를 넘어서,
// API의 기능적 측면을 나타내며, 클라이언트가 서버와 어떻게 상호작용할 것인지에 대한 규칙과 정보를 포함하는 더 포괄적인 개념
// [path, httpMethod, header, queryParameters, bodyParameters] .. 뭐가 더 있을까?
class EndPoint<R>: ResponseRequestable {
    
    typealias Response = R
    
    let path: String
    let method: HTTPMethodType
    let headerParameters: [String: String]
    let queryParameters: [String: String]
    let bodyParameters: [String: String]
    let responseDecoder: JSONDecoder
    
    init(
        path: String,
        method: HTTPMethodType,
        headerParameters: [String: String] = [:],
        queryParameters: [String: String] = [:],
        bodyParameters: [String: String] = [:],
        responseDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.path = path
        self.method = method
        self.headerParameters = headerParameters
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.responseDecoder = responseDecoder
    }
}

// HTTP "Request"를 위한 기본적인 구성요소
protocol Requestable {
    var path: String { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParameters: [String: String] { get }
    var bodyParameters: [String: String] { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

// HTTP "Request"를 위한 기본적인 구성요소를 상속받고, 여기에 더해 "Response" 까지 고려한 프로토콜
protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: JSONDecoder { get }
}

extension Requestable {
    // url(uri) 생성과 urlRequest를 나누었을때
    // url(uri) 생성단: baseURL + path + queryParameters
    // urlRequest 생성단: headerParameters, bodyParameters, httpMethod
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let baseURL = config.baseURL.absoluteString
        let endPoint = baseURL.appending(path)
        var urlComponents = URLComponents(string: endPoint)
        urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $1, value: $0) }
        
        guard let url = urlComponents?.url else {
            throw NetworkError.urlGeneration
        }
        
        var urlRequest = URLRequest(url: url)
        var allHeaders = config.headers
        headerParameters.forEach { allHeaders.updateValue($1, forKey: $0) }
        
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}

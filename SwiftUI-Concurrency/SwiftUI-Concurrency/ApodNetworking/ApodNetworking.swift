//
//  ApodNetworking.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/10.
//

import Foundation
import UIKit

// TODO: Sendable 프로토콜이란
// TODO: async throws의 역할
public protocol ApodNetworking: Sendable {
    func fetchApods(count: Int) async throws -> [ApodModel]
    func fetchApods(startDate: Date, endDate: Date) async throws -> [ApodModel]
    
    func fetchImage(url: String) async throws -> UIImage
}

enum ApodNetworkingErorr: Error {
    case invalidServerResponse
    case parsingFailure
    case invalidURL
    case unableToCreateImage
}

// TODO: actor의 역할
public actor DefaultApodNetworking: ApodNetworking {
    let decoder: JSONDecoder
    let urlBuilder: URLBuilder
    
    // Swift6에서는 actor의 초기화 시 convenience가 필요하지 않음
    public /*convenience*/ init(jsonDecoder: JSONDecoder, urlBuilder: URLBuilder) {
        self.decoder = jsonDecoder
        self.urlBuilder = urlBuilder
    }
    
    public func fetchApods(count: Int) async throws -> [ApodModel] {
        let endPoint = ApodEndPoint.apod
        
        let parameters = [
            APodParameter.count("\(count)"),
            APodParameter.apiKey
        ]
        let url = try urlBuilder.build(endPoint: endPoint, parameters: parameters)
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ApodNetworkingErorr.invalidServerResponse
        }
        
        let parsedData = try decoder.decode([ApodModel].self, from: data)
        
        return parsedData
    }
    
    public func fetchApods(startDate: Date, endDate: Date) async throws -> [ApodModel] {
        let endPoint = ApodEndPoint.apod
        let parameters = [
            APodParameter.startDate(startDate),
            APodParameter.endDate(endDate),
            APodParameter.apiKey
        ]
        
        let url = try urlBuilder.build(endPoint: endPoint, parameters: parameters)
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ApodNetworkingErorr.invalidServerResponse
        }
        
        let parsedData = try decoder.decode([ApodModel].self, from: data)
        
        return parsedData
    }
    
    public func fetchImage(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else {
            throw ApodNetworkingErorr.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ApodNetworkingErorr.invalidServerResponse
        }
        
        guard let image = UIImage(data: data) else {
            throw ApodNetworkingErorr.unableToCreateImage
        }
        
        return image
    }
}

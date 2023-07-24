//
//  BookNetworking.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/24.
//

import Foundation

protocol BookNetworking: Sendable {
    func fetchNewBooks() async throws -> BookModel
    func fetchBookDetail(isbn13: String) async throws -> BookModel
    func searchBook(at word: String, page: Int) async throws -> BookModel
}

enum BookNetworkingError: Error {
    case invaildServerResponse
    case parsingFailure
    case invalidURL
    case unableToCreateImage
}

public actor DefaultBookNetworking: BookNetworking {
    
    let decoder: JSONDecoder
    let urlBuilder: URLBuilder
    
    init() {
        self.decoder = JSONDecoder()
        self.urlBuilder = DefaultURLBuilder()
    }
    
    func fetchNewBooks() async throws -> BookModel {
        let endPoint = BookAPI.book
        
        let url = try urlBuilder.build(endPoint: endPoint, parameters: [])
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw BookNetworkingError.invaildServerResponse
        }
        
        let parsedData = try decoder.decode(BookModel.self, from: data)
        
        return parsedData
    }
    
    func fetchBookDetail(isbn13: String) async throws -> BookModel {
        let endPoint = BookAPI.detail(isbn13)
        
        let url = try urlBuilder.build(endPoint: endPoint, parameters: [])
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw BookNetworkingError.invaildServerResponse
        }

        let parsedData = try decoder.decode(BookModel.self, from: data)

        return parsedData
    }
    
    func searchBook(at word: String, page: Int) async throws -> BookModel {
        let endPoint = BookAPI.search(word, page)
        
        let url = try urlBuilder.build(endPoint: endPoint, parameters: [])
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw BookNetworkingError.invaildServerResponse
        }

        let parsedData = try decoder.decode(BookModel.self, from: data)

        return parsedData
    }
}

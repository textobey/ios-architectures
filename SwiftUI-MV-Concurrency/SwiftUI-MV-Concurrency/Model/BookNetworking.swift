//
//  BookNetworking.swift
//  SwiftUI-MV-Concurrency
//
//  Created by 이서준 on 2023/08/29.
//

import Foundation

protocol BookNetworking: Sendable {
    func request<T: Decodable>(_ api: BookAPI) async throws -> T
}

public actor DefaultBookNetworking: BookNetworking {
    
    let decoder: JSONDecoder
    
    init() {
        self.decoder = JSONDecoder()
    }
    
    func request<T: Decodable>(_ api: BookAPI) async throws -> T {
        guard let url = api.url else {
            throw BookError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw BookError.serverError
            }

            do {
                let parsedData = try decoder.decode(T.self, from: data)
                return parsedData
            } catch {
                throw BookError.parsingFailure
            }
            
        } catch {
            throw error
        }
    }
    
}

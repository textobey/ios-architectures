//
//  JSONDecoderFactory.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/10.
//

import Foundation

struct JSONDecoderFactory {
    static func defaultApodJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
}

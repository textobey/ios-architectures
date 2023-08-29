//
//  BookError.swift
//  SwiftUI-MV-Concurrency
//
//  Created by 이서준 on 2023/08/29.
//

import Foundation

enum BookError: Error {
    case invaildServerResponse
    case parsingFailure
    case serverError
    case invalidURL
    case unableToCreateImage
}

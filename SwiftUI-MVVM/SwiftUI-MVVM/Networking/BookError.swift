//
//  BookError.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 1/11/24.
//

import Foundation

enum BookErrorReason: Int {
    case badServerResponse = -1
    case retryExceeded = -2
    case invalidToken = 1
    case cannotConnectToHost = 3
    case serverIsBusy = 7
}

struct BookError: Error {
    var api: BookAPI
    var reason: BookErrorReason
    var retryCount: Int
}

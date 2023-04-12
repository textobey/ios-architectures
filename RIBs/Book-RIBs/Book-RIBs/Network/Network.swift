//
//  Network.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/12.
//

import Foundation
import Moya
import RxSwift

protocol Network {
    func request<T: Decodable>(
        _ api: BookAPI,
        file: StaticString,
        function: StaticString,
        line: UInt
    ) -> ReturnResult<T, Error>
}

extension Network {
    func request<T: Decodable>(
        _ api: BookAPI,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> ReturnResult<T, Error> {
        return self.request(api, file: file, function: function, line: line)
    }
}

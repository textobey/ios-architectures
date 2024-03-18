//
//  NetworkSerivce.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/14/24.
//

import Foundation
import Combine

protocol NetworkSerivce {
    typealias CompletionHandler = (Result<Data?, Error>) -> Void
    
    func request(completion: @escaping CompletionHandler) -> Cancellable?
}

//final class DefaultNetworkSerivce: NetworkSerivce {
//    func request(completion: @escaping CompletionHandler) -> Cancellable? {
//
//    }
//}

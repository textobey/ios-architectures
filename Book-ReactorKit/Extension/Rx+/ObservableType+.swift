//
//  ObservableType+.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2023/01/17.
//

import ReactorKit
import RxSwift
import RxCocoa

extension ObservableType {
    func mapVoid() -> Observable<Void> {
        return map { _ in Void() }
    }
    
    func flatMapEmpty() -> Observable<Self.Element> {
        return flatMap { _ in Observable<Self.Element>.empty() }
    }
}

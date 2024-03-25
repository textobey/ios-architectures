//
//  ViewModelType.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/25/24.
//

import Foundation
import Combine

protocol ViewModelType {
    associatedtype ActionType
    associatedtype State
    
    typealias Input = AnyPublisher<ActionType, Never>
    typealias Output = AnyPublisher<State, Never>
    
    func transform(input: Input) -> Output
}

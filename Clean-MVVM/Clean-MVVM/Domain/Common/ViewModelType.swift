//
//  ViewModelType.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/25/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype State
    associatedtype Output
    
    func transform(input: Input) -> Output
}

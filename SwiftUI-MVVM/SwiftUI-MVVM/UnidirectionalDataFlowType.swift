//
//  UnidirectionalDataFlowType.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/14/23.
//

import Foundation

protocol UnidirectionalDataFlowType {
    associatedtype InputType
    
    func transform(_ input: InputType)
}

//
//  Counter.swift
//  MyOceanTests
//
//  Created by 이서준 on 2/26/24.
//

import Foundation

class Counter {
    private var value = 0
    
    func increment() {
        value += 1
    }
    
    func getValue() -> Int {
        return value
    }
}

actor MyActorCounter {
    private var value = 0
    
    func increment() {
        value += 1
    }
    
    func getValue() -> Int {
        return value
    }
}

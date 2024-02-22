//
//  CloudSerivce.swift
//  MyOceanTests
//
//  Created by 이서준 on 2/21/24.
//

import Foundation

protocol AnyService {
    var value: Int { get }
    
    func someAsyncOperation()
    func anotherAsyncOperation(completionHandler: @escaping () -> Void)
    func asyncAwaitCall() async throws -> Data
}

class CloudService: AnyService {
    var value: Int = 0
    
    func someAsyncOperation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.value = 1
        }
    }
    
    func anotherAsyncOperation(completionHandler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.value = 77
            completionHandler()
        }
    }
    
    func asyncAwaitCall() async throws -> Data {
        let url = URL(string: "https://images.unsplash.com/photo-1697208254530-eb42576be354?auto=format&fit=crop&q=80&w= 3686&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return data
    }
}

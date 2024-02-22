//
//  MockCloudService.swift
//  MyOceanTestsTests
//
//  Created by 이서준 on 2/21/24.
//

import Foundation
@testable import MyOceanTests

class MockCloudSerivce: AnyService {
    var value: Int = 0
    
    // 비동기 테스트 코드를 작성하는 방법
    // 1. Mocking 모듈을 작성하여 비동기 작업을 동기 작업으로 변경함
    func someAsyncOperation() {
        value = 1
    }
    
    func anotherAsyncOperation(completionHandler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.value = 77
            completionHandler()
        }
    }
    
    func asyncAwaitCall() async throws -> Data {
        return Data()
    }
}

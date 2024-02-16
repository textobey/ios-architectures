//
//  MockNetworkService.swift
//  MyOceanTestsTests
//
//  Created by 이서준 on 2/16/24.
//

import XCTest
@testable import MyOceanTests

// Mocking: 실제 개체나 종속성을 대신할 모의 개체를 만드는 것을 의미
// 이러한 Mocking 개체는 실제의 동작을 모방하지만 테스트 중에 상호 작용을 제어하고 관찰하는 것이 가능하다.
//
// 왜 이런게 필요할까?
// 예를 들어, 테스트할때마다 5초씩 걸리는 네트워크 통신 작업이 있다고 가정해보자.
// 이런 느린 다운로드 속도를 기다리면서 테스트하는것은 효율적이지 못하고,
// 테스트하고자 하는 when에 의해서가 아닌 개체, 종속성의 문제 발생으로 인해 테스트가 실패하게 된다.
//
// 이런 부분으로 인해 네트워크 요청이나 데이터베이스와 같은 실제 종속성은
// 느리거나, 신뢰할 수 없거나, 비용이 많이 들기도 하기 때문에, Mocking 개체를 만들어 사용하면
// 단위 테스트를 더 빠르고 효율적으로 이뤄낼 수 있다.

final class MockNetworkService: AnyNetworkService {
    var isSuccessCase: Bool = true
    
    func looooogNetworkCall(_ completionHandler: @escaping (Result<UIImage, Error>) -> ()) {
        if isSuccessCase {
            completionHandler(.success(UIImage()))
        } else {
            completionHandler(.failure(MockError.failure))
        }
    }
}

enum MockError: Error {
    case failure
}

//
//  MyOceanTestsTests.swift
//  MyOceanTestsTests
//
//  Created by 이서준 on 1/29/24.
//

import XCTest
import Combine
@testable import MyOceanTests

// XCTestCase: 테스트 케이스, 테스트 방법, 성능 테스틀 정의하기 위한 기본 클래스
final class MyOceanTestsTests: XCTestCase {
    
    // 매 테스트 전에 초기화하기 때문에 강제로 언래핑 하는것이 안전하고, 사용하기에 편리함
    var sut: DeepOceanViewModel!
    var mockNetworkSerivce: MockNetworkService!
    
    // 테스트 시작 전에 딱 한번만 호출되는 타입메서드
    //override class func setUp() { }}
    
    // 각 테스트 시작시에 호출되는 메서드
    override func setUp() {
        super.setUp()
        mockNetworkSerivce = MockNetworkService()
        sut = DeepOceanViewModel(networkService: mockNetworkSerivce, cloudService: MockCloudSerivce())
    }
    
    // 테스트 뒷정리의 개념
    // 중복배제
    override func tearDown() {
        // 테스트의 마지막 단계에서는 sut 초기화를 제거(안하면 메모리에 테스트가 남게됨)
        sut = nil
        mockNetworkSerivce = nil
        super.tearDown()
    }
    
    func test_sumPositiveNumbers() {
        // given
        // System Under Test. 테스트중인 시스템
        
        // when
        let result = sut.sum(3, 5)
        
        // then
        XCTAssertEqual(result, 9, "3 더하기 5는 8이 되어야함")
    }
    
    func test_multiplyPositiveNumbers() {
        // when
        let result = sut.multiply(3, 5)
        
        // then
        XCTAssertEqual(result, 15, "3 곱하기 5는 15가 되어야함")
    }
    
    func test_DeepOceanViewModel_downloadWallPaper_didGetImage() {
        // given
        let expectation = XCTestExpectation(description: #function)
        
        // when
        sut.downloadWallPaper()
        
        let listener = sut.$uiImage.dropFirst().sink { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        // then
        XCTAssertNotNil(sut.uiImage)
    }
    
    func test_DeepOceanViewModel_downloadWallPaper_didGetError() {
        // given
        let expectation = XCTestExpectation(description: #function)
        mockNetworkSerivce.isSuccessCase = false
        
        // when
        sut.downloadWallPaper()
        
        let listener = sut.$error.sink { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        // then
        XCTAssertNotNil(sut.error)
    }
    
    // MARK: 비동기 테스트 코드를 작성하는 방법
    
    // case1: Mocking으로 동기 코드를 이루게하기
    func test_DeepOceanViewModel_callSomeAsyncOperation_didIncreaseValue() {
        // given
        // 만약 MockingCloudService가 아닌 CloudService()를 활용하면 이 테스팅은 실패할것임.
        // 왜냐면, 이 테스트 코드는 sync하게 수행이 되는데
        // MockingCloudService는 그에 맞춰 비동기 작업을 동기 코드로 수정하였고,
        // CloudService는 비동기 작업을 그대로 수행하기 때문에, 테스트가 완료된 이후에나 비동기 작업이 완료됨
        
        // when
        sut.callSomeAsyncOperation()
        
        // then
        XCTAssertEqual(sut.cloudService.value, 1, "value는 1이 되어야 합니다.")
    }
    
    // case2: XCTestExpectation API를 활용하기
    func test_DeepOceanViewModel_anotherAsyncOperation_didCallCompletion() {
        // given
        let sut = MockCloudSerivce()
        let expectation = XCTestExpectation(description: #function)
        
        // when
        sut.anotherAsyncOperation {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        // then
        XCTAssertEqual(sut.value, 77)
    }
    
    func test_DeepOceanViewModel_searchWithDebouncer_oneExpectationFulfilled() {
        // given
        let cancelExpectation = XCTestExpectation(description: "Canceled")
        
        // expectation은 fulfill() 메서드가 호출될때 성공으로 간주되지만,
        // isInverted를 true로 설정하면 fulfill() 메서드가 호출되지 않을 때 성공하게 됨
        cancelExpectation.isInverted = true
        
        let completedExpectation = XCTestExpectation(description: "Completed")
        
        // when
        sut.searchWithDebouncer("Objective-C", completionHandler: {
            // Debouncer 매커니즘에 의해 fulfill() 메서드가 호출되지 않는 것이 정상적
            cancelExpectation.fulfill()
        })
        
        sut.searchWithDebouncer("Swift", completionHandler: {
            completedExpectation.fulfill()
        })
        
        // then
        wait(for: [cancelExpectation, completedExpectation], timeout: 3)
    }
    
    // Swift Concurrency async/await을 활용하여 XCTestExpectation 없이 비동기 코드를
    // 동기 코드처럼(straight하게) 작성하고 테스트를 진행할 수 있음
    func test_DeepOceanViewModel_callAsyncAwaitCloudSerivce_didGetImage() async {
        // when
        let image = try? await sut.cloudService.asyncAwaitCall()
        
        // then
        XCTAssertNotNil(image)
    }
}

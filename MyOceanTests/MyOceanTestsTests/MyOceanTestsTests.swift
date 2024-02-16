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
        sut = DeepOceanViewModel(networkService: mockNetworkSerivce)
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
}

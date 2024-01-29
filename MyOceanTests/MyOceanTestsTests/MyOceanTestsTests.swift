//
//  MyOceanTestsTests.swift
//  MyOceanTestsTests
//
//  Created by 이서준 on 1/29/24.
//

import XCTest
@testable import MyOceanTests

// XCTestCase: 테스트 케이스, 테스트 방법, 성능 테스틀 정의하기 위한 기본 클래스
final class MyOceanTestsTests: XCTestCase {
    
    // 매 테스트 전에 초기화하기 때문에 강제로 언래핑 하는것이 안전하고, 사용하기에 편리함
    var sut: DeepOceanViewModel!
    
    // 테스트 시작 전에 딱 한번만 호출되는 타입메서드
    //override class func setUp() { }}
    
    // 각 테스트 시작시에 호출되는 메서드
    override func setUp() {
        super.setUp()
        sut = DeepOceanViewModel()
    }
    
    // 테스트 뒷정리의 개념
    // 중복배제
    override func tearDown() {
        // 테스트의 마지막 단계에서는 sut 초기화를 제거(안하면 메모리에 테스트가 남게됨)
        sut = nil
        super.tearDown()
    }
    
    func test_sumPositiveNumbers() {
        // given
        // System Under Test. 테스트중인 시스템
        let sut = DeepOceanViewModel()
        
        // when
        let result = sut.sum(3, 5)
        
        // then
        XCTAssertEqual(result, 9, "3 더하기 5는 8이 되어야함")
    }
    
    func test_multiplyPositiveNumbers() {
        let sut = DeepOceanViewModel()
        
        let result = sut.multiply(3, 5)
        
        XCTAssertEqual(result, 15, "3 곱하기 5는 15가 되어야함")
    }
}

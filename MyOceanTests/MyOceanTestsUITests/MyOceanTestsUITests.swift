//
//  MyOceanTestsUITests.swift
//  MyOceanTestsUITests
//
//  Created by 이서준 on 1/29/24.
//

import MyOceanTests
import XCTest

final class MyOceanTestsUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        // 테스트 중 하나라도 문제가 발생했을때, 바로 멈춰서 수정하고 싶다면 false
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
        
    }
    
    func testExample() throws {
        // 테스트하려는 앱(전체 앱)을 의미
        let app = XCUIApplication()
        // 실제 아이폰에서 앱을 실행하는것처럼 앱을 실행하는 메서드
        app.launch()
    }
    
    // 앱이 Launch 될 때, 얼마나 빨리 시작되는지와 같이 애
    func testLaunchPerformance() throws {
        // measure: 무엇을 측정하고 싶을때,
        // XCTApplicationLaunchMetric 앱이 시작되는데 걸리는 시간을 측정하고 싶어.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            // 앱 시작
            XCUIApplication().launch()
        }
    }
}

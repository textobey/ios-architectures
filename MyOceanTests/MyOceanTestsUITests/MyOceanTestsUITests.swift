//
//  MyOceanTestsUITests.swift
//  MyOceanTestsUITests
//
//  Created by 이서준 on 1/29/24.
//

import MyOceanTests
import XCTest

final class MyOceanTestsUITests: XCTestCase {
    
    // given-when-then 패턴은 테스트를 할때 많이 사용되는 패턴중 하나
    // given(준비): 이 단계에서는 테스트의 사전 조건을 설정한다. 예를 들어, 특정 객체를 초기화하거나 mock데이터를 준비하는 작업을 수행
    // when(실행): 이 단계에서는 실제로 테스트하려는 동작을 수행한다. 예를 들어, 특정 메서드를 호출하거나 UI 인터랙션을 시뮬레이션하는 작업을 수행
    // then(확인): 이 단계에서는 테스트의 결과를 검증한다. 예를 들어, 특정 메서드가 예상대로 return 되었는지, 특정 상태가 업데이트 되었는지 확인

    override func setUp() {
        super.setUp()
        // 각 테스트가 시작할때마다 app.launch()를 수행하여, 각 메서드에서 호출하지 않아도 되도록 최적화
        //let app = XCUIApplication()
        //app.launch()
        
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
    
    func test_deepOceanView_textRegistration_isPresent() {
        // given
        let app = XCUIApplication()
        app.launch()
        let registrationStaticText = app.staticTexts["Registration"]
        
        // then
        // exists: 요소가 화면에 존재하는지 확인하는 테스트에 필요한 프로퍼티
        XCTAssertTrue(registrationStaticText.exists, "Text presents")
    }
    
    func test_deepOceanView_userNameTextField_didCallKeyboard() {
        // given
        let app = XCUIApplication()
        app.launch()
        let textField = app.textFields["UserName"]
        
        // 키보드가 처음에 표시되지 않는지 확인
        XCTAssertFalse(app.keyboards.element.exists, "Keyboard is not initially visible")
        
        // when
        textField.tap()
        
        // then
        XCTAssertTrue(app.keyboards.element.exists, "Keyboard is visible after tapping the text field")
    }
    
    func test_shallowOceanView_signupButton_didMakeNavigation() {
        // given
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["UserName"].tap()
        
        //한영전환인데, 왜 안되지?
        //app.buttons["Next keyboard"].tap()
        
        // when
        let aKey = app.keys["ㅏ"]
        aKey.tap()
        aKey.tap()
        
        let bKey = app.keys["ㅂ"]
        bKey.tap()
        bKey.tap()

        app.buttons["Sign Up"].tap()

        // then
        let helloWorldStaticText = app.staticTexts["Welcome"]
        XCTAssertTrue(helloWorldStaticText.exists, "Welcome exists")
    }
    
    func test_shallowOceanView_backButton_didNavigationBack() {
        // given
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["UserName"].tap()
        
        let aKey = app.keys["ㅏ"]
        aKey.tap()
        aKey.tap()
        
        let bKey = app.keys["ㅂ"]
        bKey.tap()
        bKey.tap()

        app.buttons["Sign Up"].tap()

        
        let helloWorldStaticText = app.staticTexts["Welcome"]
        XCTAssertTrue(helloWorldStaticText.exists, "Welcome exists")
        
        // when
        app.navigationBars["Welcome"].buttons["Back"].tap()
        
        // then
        let registrationStaticText = app.staticTexts["Registration"]
        XCTAssertTrue(registrationStaticText.exists, "Text exists")
    }
    
    // TODO: UserName이 입력되지 않았을경우, 가입 버튼을 비활성화시키고 화면이동이 되지 않음을 확인하는 테스트(완료)
    // 궁금한점. push/pop 동작이 이루어지지 않았음을 특정 UI의 존재유무에 의존하는게 맞을까?
    func test_shallowOceanView_singupButton_didNotMakeNavigation() {
        // given
        let app = XCUIApplication()
        app.launch()
        
        // when
        app.buttons["Sign Up"].tap()
        
        // then
        let welcomeStaticText = app.staticTexts["Welcome"]
        XCTAssertFalse(welcomeStaticText.exists, "Welcome not exists")
    }
}

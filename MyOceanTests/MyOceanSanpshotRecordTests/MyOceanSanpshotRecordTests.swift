//
//  MyOceanSanpshotRecordTests.swift
//  MyOceanSanpshotRecordTests
//
//  Created by 이서준 on 2/20/24.
//

import XCTest
import SnapshotTesting

@testable import MyOceanTests
import SwiftUI

final class MyOceanSanpshotRecordTests: XCTestCase {

    //func test_JokeView_didNotChange() {
        // given
        //let viewModel = DeepOceanViewModel(networkService: MockNetworkService())
        //let view = JokeView(viewModel: viewModel)
        
        // 동일한 동작
        //isRecording = true
        //assertSnapshot(of: view, as: .image, record: true)
        
        // then
        //assertSnapshot(of: view, as: .image, record: true)
    //}
    
    
    // swift-snapshot-testing의 강점은 대부분의 스냅샷 라이브러리는 UIView의 UIImage로 제한되지만,
    // SnapshotTesting은 모든 Swift 플랫폼에서 UIView의 포맷으로 작동 가능
    func test_JokeView_isSame() {
        // given
        let viewModel = DeepOceanViewModel(networkService: MockNetworkService(), cloudService: CloudService())
        let view = JokeView(viewModel: viewModel)
        
        // kaleidoscope라는 compare앱에 실패 로그를 출력하도록 구성할수있나봄
        //diffTool = "ksdiff"
        
        // isRecoding으로 처리하는 새로운 기록은 메서드 내부에 모두 적용되는 글로벌?적인 느낌
        //isRecording = true
        
        // then
        // assertSnapshot에서 추가하는 record는 단일 어설션에 대해서 기록하는 느낌
        assertSnapshot(of: view, as: .image)
    }

    func test_JokeDetailView_didNotChange() {
        let view = JokeDetailView(joke: "Hello friend!")
        
        assertSnapshot(of: view, as: .image)
    }
    
    func test_buttonDefaultState() {
        let button = LoadingButton()
        
        // 이미지 저장이 "testName.named" 포맷으로 저장됨
        let result = verifySnapshot(of: button, as: .image, named: "Default", testName: "Button")
        
        XCTAssertNil(result)
    }
    
    func test_buttonLoadingState() {
        let button = LoadingButton(isLoading: true)

        let result = verifySnapshot(of: button, as: .image, named: "isLoading", testName: "Button")
        
        XCTAssertNil(result)
    }
    
    // 장치별 스냅샷 확인
    func test_contentViewDefaultState() {
        // given
        let view = UIHostingController(rootView: ContentView())
        
        let divices: [String: ViewImageConfig] = [
            "iPhoneX": .iPhoneX,
            "iPhone8": .iPhone8,
            "iPhoneSE": .iPhoneSe
        ]
        
        let results = divices.map { device in
            verifySnapshot(of: view, as: .image(on: device.value))
        }
        
        results.forEach { XCTAssertNil($0) }
    }
}

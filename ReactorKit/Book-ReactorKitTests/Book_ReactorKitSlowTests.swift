//
//  Book_ReactorKitSlowTests.swift
//  Book-ReactorKitTests
//
//  Created by 이서준 on 2023/08/02.
//

import XCTest
@testable import Book_ReactorKit

final class Book_ReactorKitSlowTests: XCTestCase {
    
    var sut: URLSession!
    let networkMonitor = NetworkMonitor.shared

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    // 테스트 대상은 외부 환경에 의존하면 안되기 때문에,
    // 네트워크 통신의 경우 실제로 API Request를 할 경우,
    // 시간이 소요되고 DB가 변경되거나 실제 서버의 프로덕션 환경을 오염시킬 가능성이 있음
    // 그렇기 때문에, 이런 경우에는 Stub을 구성하여 테스트 코드를 작성할 수 있도록 해야함

    func testFetchBookApiCompletes() throws {
        try XCTSkipUnless(networkMonitor.isReachable, "네트워크 연결이 필요합니다.")
        
        // given
        let urlString = "https://api.itbook.store/1.0/new"
        let url = URL(string: urlString)!
        let promise = expectation(description: "CompletionHandler 호출")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sut.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

    func testFetchBookApiResponseParseComplete() throws {
        try XCTSkipUnless(networkMonitor.isReachable, "네트워크 연결이 필요합니다.")
        
        // given
        let urlString = "https://api.itbook.store/1.0/new"
        let url = URL(string: urlString)!
        let promise = expectation(description: "CompletionHandler 호출")
        var jsonData: Data?
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sut.dataTask(with: url) { data, response, error in
            jsonData = data
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNotNil(jsonData, "failed Parse")
        
        let expectation: BookModel? = try JsonLoader.decode(of: jsonData!, to: BookModel.self)
        XCTAssertNotNil(expectation)
    }
}

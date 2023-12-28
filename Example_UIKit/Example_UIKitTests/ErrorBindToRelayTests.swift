//
//  ErrorBindToRelayTests.swift
//  Example_UIKitTests
//
//  Created by 이서준 on 12/28/23.
//

import XCTest
import RxSwift
import RxRelay

final class ErrorBindToRelayTests: XCTestCase {
    
    private var disposeBag: DisposeBag!
    
    private let somePublishRelay = PublishRelay<Int>()
    
    private enum TestError: Int, Error {
        case disconnected = -1
    }
    
    override func setUp() {
        disposeBag = DisposeBag()
    }
    
    func test_WhenErrorBindingAtRelayWithCatch() {
        let expectation = XCTestExpectation(description: "test_WhenErrorBindingAtRelayWithCatch")
        
        somePublishRelay
            .subscribe(onNext: { element in
                print(element)
            })
            .disposed(by: disposeBag)
        
        let observable = Observable<Int>.create { observer in
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            observer.onError(TestError.disconnected)
            return Disposables.create()
        }
        
        observable
            // 아래 catch 오퍼레이터를 주석처리하면 fatalError를 확인할 수 있음
            .catch { error in
                print("❎ \(#function) error: \(error)")
                XCTAssertEqual(error as? TestError, TestError.disconnected)
                expectation.fulfill()
                return Observable.empty()
            }
            .bind(to: somePublishRelay)
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3)
    }
}

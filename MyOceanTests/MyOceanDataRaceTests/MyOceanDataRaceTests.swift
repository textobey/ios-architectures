//
//  MyOceanDataRaceTests.swift
//  MyOceanDataRaceTests
//
//  Created by 이서준 on 2/26/24.
//

import XCTest
@testable import MyOceanTests

final class MyOceanDataRaceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /*
     왜 테스트에 통과하지?
     heap 영역에 존재하는 Counter 'value' 공유자원에 여러 스레드에서 동시에 접근하는 예제코드
     여러 스레드에서 value를 동시에 증가시키려고 하면, 예상치 못한 결과(데이터 경합)이 발생할 수 있음.
     그러나, 실제로 테스트를 돌려보면 항상 2000이 출력되고 테스트에 통과되는 것을 확인할 수 있음.
     왜냐면, CPU의 코어 수, 스레드 스케줄링, 작업의 수행 속도 등 여러 요인에 따라 달라지기 때문
     데이터 경합은 잠재적으로 존재하며, 특정 조건에 따라 드러나기 때문에 디버깅이 어렵다.
     => 아래 코드도 결과는 2000이지만 데이터 경합이 발생하지 않는다는 것을 의미하진 않는다.
     */
    func test_counter_increase_hasDataRace() {
        // given
        let sut = Counter()
        
        // when
        DispatchQueue.global().async {
            for _ in 0 ..< 1000 {
                sut.increment()
            }
        }
        
        DispatchQueue.global().async {
            for _ in 0 ..< 1000 {
                sut.increment()
            }
        }
        
        // then
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(sut.getValue(), 2000, "counter의 value는 2000이어야 합니다.")
        }
    }
    
    // 세마포어를 활용하여 공유 리소스에 접근하는 스레드의 수를 제한하여 데이터 경합을 방지
    // 각 작업마다 대기/해제를 하는 것이 꼭 async/await과 닮은거 같기도?
    func test_counterValue_increase_with_DispatchSemaphore() {
        // given
        let sut = Counter()
        let semaphore = DispatchSemaphore(value: 1)
        
        // when
        DispatchQueue.global().async {
            for _ in 0 ..< 1000 {
                semaphore.wait()
                sut.increment()
                semaphore.signal()
            }
        }
        
        DispatchQueue.global().async {
            for _ in 0 ..< 1000 {
                semaphore.wait()
                sut.increment()
                semaphore.signal()
            }
        }
        
        // then
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(sut.getValue(), 2000, "counter의 value는 2000이어야 합니다.")
        }
    }
    
    func test_ActorCounter() async {
        let sut = MyActorCounter()
        
        await Task {
            let task1 = Task {
                for _ in 0 ..< 10_000 {
                    await sut.increment()
                }
            }
            
            let task2 = Task {
                for _ in 0 ..< 10_000 {
                    await sut.increment()
                }
            }
            
            await task1.result
            await task2.result
        }.result
        
        print(await sut.getValue())
    }
    
    // MARK: actor
    
    //func test_bankViewModel_transfer_withAsyncAwait() async {
    //    // given
    //    let sut = BankViewModel()
    //
    //    // when
    //    await sut.update()
    //
    //    let account1Balance = await sut.account1.balanceConfig()
    //    let account2Balance = await sut.account2.balanceConfig()
    //
    //    print(account1Balance, account2Balance)
    //
    //    // then
    //    XCTAssertEqual(account1Balance, 100)
    //    XCTAssertEqual(account2Balance, 50)
    //}
}

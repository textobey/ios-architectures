//
//  MyOceanSnapshotTests.swift
//  MyOceanSnapshotTests
//
//  Created by 이서준 on 2/19/24.
//

import XCTest
import SnapshotTesting

@testable import MyOceanTests

final class MyOceanSnapshotTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_DeepOceanView_didNotChange() {
        // given
        let viewModel = DeepOceanViewModel(networkService: MockNetworkService())
        let view = JokeView(viewModel: viewModel)
        
        // then
        assertSnapshot(of: view, as: .image)
    }
}

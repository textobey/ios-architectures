//
//  MockNetworkService.swift
//  MyOceanSnapshotTests
//
//  Created by 이서준 on 2/19/24.
//

import UIKit
@testable import MyOceanTests

final class MockNetworkService: AnyNetworkService {
    func fetchJokeList() -> [String] {
        return []
    }
    
    func looooogNetworkCall(_ completionHandler: @escaping (Result<UIImage, Error>) -> ()) {
        completionHandler(.success(UIImage()))
    }
}

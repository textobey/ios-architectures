//
//  MockNetworkService.swift
//  MyOceanSanpshotRecordTests
//
//  Created by 이서준 on 2/20/24.
//

import UIKit
@testable import MyOceanTests

final class MockNetworkService: AnyNetworkService {
    func fetchJokeList() -> [String] {
        return [
            "Why did the iOS developer go broke? Because they had too many connections, but none of them were personal!",
            "What do you call a group of iOS developers working on a networking project? The Inter-NETworking Team!",
            "Why did the Wi-Fi network apply for a job? Because it wanted to make better connections!"
        ]
    }
    
    func looooogNetworkCall(_ completionHandler: @escaping (Result<UIImage, Error>) -> ()) {
        completionHandler(.success(UIImage()))
    }
}

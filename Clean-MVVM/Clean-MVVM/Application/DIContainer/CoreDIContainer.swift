//
//  CoreDIContainer.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/22/24.
//

import Foundation

// TODO:
// 1. AppDIContainer를 만드는 방법.. 어떻게 나눌까? Scene별로? Layer별로? Library를 써서?
// 2. ServiceLocator vs DI
// 3. ServiceLocator는 안티패턴인가, Swinject는 ServiceLocator인가?

final class CoreDIContainer {
    
    let networkConfig: NetworkConfigurable
    
    init(
        networkConfig: NetworkConfigurable = BookAPINetworkConfig(
            baseURL: URL(string: "https://api.itbook.store")!,
            headers: [:],
            queryParameters: [:]
        )
    ) {
        self.networkConfig = networkConfig
    }
    
    lazy var networkService: NetworkSerivce = {
        let defaultNetworkService = DefaultNetworkSerivce(config: networkConfig)
        return defaultNetworkService
    }()
    
    lazy var dataTransferService: DataTransferService = {
        let defaultDataTransferService = DefaultDataTransferService(networkSerivce: networkService)
        return defaultDataTransferService
    }()
    
}
 

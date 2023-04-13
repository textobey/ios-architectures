//
//  AppComponent.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import Foundation
import RIBs
import RxSwift

final class AppComponent: Component<EmptyDependency>, RootDependency {
    
    let network: Network
    let services: ServiceProviderType
    
    init() {
        self.network = NetworkImpl()
        self.services = ServiceProvider()
        super.init(dependency: EmptyComponent())
    }
}

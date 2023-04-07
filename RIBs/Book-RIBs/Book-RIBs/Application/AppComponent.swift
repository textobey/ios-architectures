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
    
    let service: ServiceProviderType
    
    init() {
        self.service = ServiceProvider()
        super.init(dependency: EmptyComponent())
    }
}

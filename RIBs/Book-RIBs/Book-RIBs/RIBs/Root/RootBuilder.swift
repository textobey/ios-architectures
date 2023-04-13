//
//  RootBuilder.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/11.
//

import RIBs

protocol RootDependency: Dependency {
    var network: Network { get }
    var services: ServiceProviderType { get }
}

final class RootComponent: Component<RootDependency>,
                           NewBookDependency,
                           SearchBookDependency {

    var network: Network {
        dependency.network
    }
    
    var services: ServiceProviderType {
        dependency.services
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {
    
    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }
    
    func build() -> LaunchRouting {
        let component = RootComponent(dependency: dependency)
        let tabBar = RootTabBarViewController()
        let interactor = RootInteractor(presenter: tabBar)
        
        let newBookBuilder = NewBookBuilder(dependency: component)
        let searchBookBuilder = SearchBookBuilder(dependency: component)
        
        return RootRouter(
            interactor: interactor,
            viewController: tabBar,
            newBookBuilder: newBookBuilder,
            searchBookBuilder: searchBookBuilder
        )
    }
}

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
    func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler)
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {
    
    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }
    
    func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler) {
        let component = RootComponent(dependency: dependency)
        let tabBar = RootTabBarViewController()
        let interactor = RootInteractor(presenter: tabBar)
        
        let newBookBuilder = NewBookBuilder(dependency: component)
        let searchBookBuilder = SearchBookBuilder(dependency: component)
        
        let router = RootRouter(
            interactor: interactor,
            viewController: tabBar,
            newBookBuilder: newBookBuilder,
            searchBookBuilder: searchBookBuilder
        )
        
        return (router, interactor)
    }
}

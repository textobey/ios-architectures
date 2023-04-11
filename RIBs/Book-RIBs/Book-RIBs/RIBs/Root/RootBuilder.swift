//
//  RootBuilder.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/11.
//

import RIBs

protocol RootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RootComponent: Component<RootDependency>, NewBookDependency, SearchBookDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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

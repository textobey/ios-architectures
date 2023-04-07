//
//  TabBarBuilder.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs

protocol TabBarDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TabBarComponent: Component<TabBarDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

extension TabBarComponent: NewBookDependency, SearchBookDependency { }

// MARK: - Builder

protocol TabBarBuildable: Buildable {
    func build(withListener listener: TabBarListener) -> TabBarRouting
}

final class TabBarBuilder: Builder<TabBarDependency>, TabBarBuildable {

    override init(dependency: TabBarDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TabBarListener) -> TabBarRouting {
        let component = TabBarComponent(dependency: dependency)
        let viewController = TabBarViewController()
        let interactor = TabBarInteractor(presenter: viewController)
        
        let newBookBuilder = NewBookBuilder(dependency: component)
        let searchBookBuilder = SearchBookBuilder(dependency: component)
        
        return TabBarRouter(
            interactor: interactor,
            viewController: viewController,
            newBookBuilder: newBookBuilder,
            searchBookBuilder: searchBookBuilder
        )
    }
}

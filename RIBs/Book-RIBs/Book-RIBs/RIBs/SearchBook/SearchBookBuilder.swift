//
//  SearchBookBuilder.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs

protocol SearchBookDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SearchBookComponent: Component<SearchBookDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SearchBookBuildable: Buildable {
    func build(withListener listener: SearchBookListener) -> SearchBookRouting
}

final class SearchBookBuilder: Builder<SearchBookDependency>, SearchBookBuildable {

    override init(dependency: SearchBookDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchBookListener) -> SearchBookRouting {
        let component = SearchBookComponent(dependency: dependency)
        let viewController = SearchBookViewController()
        let interactor = SearchBookInteractor(presenter: viewController)
        interactor.listener = listener
        return SearchBookRouter(interactor: interactor, viewController: viewController)
    }
}

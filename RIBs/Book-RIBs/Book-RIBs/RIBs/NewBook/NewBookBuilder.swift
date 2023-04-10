//
//  NewBookBuilder.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs

protocol NewBookDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class NewBookComponent: Component<NewBookDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol NewBookBuildable: Buildable {
    func build(withListener listener: NewBookListener) -> NewBookRouting
}

final class NewBookBuilder: Builder<NewBookDependency>, NewBookBuildable {

    override init(dependency: NewBookDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NewBookListener) -> NewBookRouting {
        let viewController = NewBookViewController()
        let interactor = NewBookInteractor(presenter: viewController)
        interactor.listener = listener
        return NewBookRouter(interactor: interactor, viewController: viewController)
    }
}

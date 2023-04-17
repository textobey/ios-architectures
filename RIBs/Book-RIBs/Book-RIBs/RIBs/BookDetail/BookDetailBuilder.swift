//
//  BookDetailBuilder.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/14.
//

import RIBs

protocol BookDetailDependency: Dependency {
    var network: Network { get }
    var services: ServiceProviderType { get }
}

final class BookDetailComponent: Component<BookDetailDependency> {
    fileprivate var network: Network {
        return dependency.network
    }
    
    fileprivate var services: ServiceProviderType {
        return dependency.services
    }
}

// MARK: - Builder

protocol BookDetailBuildable: Buildable {
    func build(
        withListener listener: BookDetailListener,
        isbn13: String
    ) -> BookDetailRouting
}

final class BookDetailBuilder: Builder<BookDetailDependency>, BookDetailBuildable {

    override init(dependency: BookDetailDependency) {
        super.init(dependency: dependency)
    }
    
    func build(
        withListener listener: BookDetailListener,
        isbn13: String
    ) -> BookDetailRouting {
        let component = BookDetailComponent(dependency: dependency)
        let viewController = BookDetailViewController()
        let interactor = BookDetailInteractor(
            presenter: viewController,
            repository: BookRepositoryImpl(network: component.network),
            serviceProvider: component.services,
            isbn13: isbn13
        )
        interactor.listener = listener
        return BookDetailRouter(interactor: interactor, viewController: viewController)
    }
}

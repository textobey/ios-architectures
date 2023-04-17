//
//  SearchBookBuilder.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs

protocol SearchBookDependency: Dependency, BookDetailDependency {
    var network: Network { get }
    var services: ServiceProviderType { get }
}

final class SearchBookComponent: Component<SearchBookDependency> {
    var network: Network {
        dependency.network
    }
    
    var services: ServiceProviderType {
        dependency.services
    }
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
        let interactor = SearchBookInteractor(
            presenter: viewController,
            repository: BookRepositoryImpl(network: component.network),
            serviceProvider: component.services
        )
        
        let bookDetailBuilder = BookDetailBuilder(dependency: dependency)
        
        interactor.listener = listener
        
        return SearchBookRouter(
            interactor: interactor,
            viewController: viewController,
            bookDetailBuilder: bookDetailBuilder
        )
    }
}

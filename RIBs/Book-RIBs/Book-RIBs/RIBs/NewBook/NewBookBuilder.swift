//
//  NewBookBuilder.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs

protocol NewBookDependency: Dependency, BookDetailDependency {
    var network: Network { get }
    var services: ServiceProviderType { get }
}

final class NewBookComponent: Component<NewBookDependency> {
    var network: Network {
        dependency.network
    }
    
    var services: ServiceProviderType {
        dependency.services
    }
}

// MARK: - Builder

protocol NewBookBuildable: Buildable {
    func build(withListener listener: NewBookListener) -> (router: NewBookRouting, actionableItem: NewBookActionableItem)
}

final class NewBookBuilder: Builder<NewBookDependency>, NewBookBuildable {

    override init(dependency: NewBookDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NewBookListener) -> (router: NewBookRouting, actionableItem: NewBookActionableItem) {
        let component = NewBookComponent(dependency: dependency)
        let viewController = NewBookViewController()
        let interactor = NewBookInteractor(
            presenter: viewController,
            repository: BookRepositoryImpl(network: component.network),
            serviceProvider: component.services
        )
        
        let bookDetailBuilder = BookDetailBuilder(dependency: dependency)
        
        interactor.listener = listener
        
        let router = NewBookRouter(
            interactor: interactor,
            viewController: viewController,
            bookDetailBuilder: bookDetailBuilder
        )
        
        return (router, interactor)
    }
}

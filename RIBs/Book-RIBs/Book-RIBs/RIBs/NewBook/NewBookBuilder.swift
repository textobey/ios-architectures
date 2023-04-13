//
//  NewBookBuilder.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs

protocol NewBookDependency: Dependency {
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
    func build(withListener listener: NewBookListener) -> NewBookRouting
}

final class NewBookBuilder: Builder<NewBookDependency>, NewBookBuildable {

    override init(dependency: NewBookDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NewBookListener) -> NewBookRouting {
        let component = NewBookComponent(dependency: dependency)
        let viewController = NewBookViewController()
        let interactor = NewBookInteractor(
            presenter: viewController,
            repository: BookRepositoryImpl(network: component.network),
            serviceProvider: component.services
        )
        interactor.listener = listener
        return NewBookRouter(interactor: interactor, viewController: viewController)
    }
}

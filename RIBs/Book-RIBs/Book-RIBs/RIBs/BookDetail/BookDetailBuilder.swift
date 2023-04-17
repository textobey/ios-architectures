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
        print("BookDetailBuilder INIT")
    }
    
    deinit {
        // 다른 컴포넌트들이 모두 Deinit 되어도 Builder는 build method에서 Routing을
        // 부모 Router에 반환하여 인스턴스가 할당 되어있는 상태라 해제되지 않는듯
        print("BookDetailBuilder DEINIT")
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

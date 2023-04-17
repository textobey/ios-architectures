//
//  NewBookRouter.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs

protocol NewBookInteractable: Interactable, BookDetailListener {
    var router: NewBookRouting? { get set }
    var listener: NewBookListener? { get set }
}

protocol NewBookViewControllable: ViewControllable {
    func pushViewController(_ viewController: ViewControllable, animated: Bool)
    func popViewController(_ animated: Bool)
}

final class NewBookRouter: ViewableRouter<NewBookInteractable, NewBookViewControllable>, NewBookRouting {
    
    private let bookDetailBuilder: BookDetailBuildable
    private var bookDetailRouting: ViewableRouting?

    init(
        interactor: NewBookInteractable,
        viewController: NewBookViewControllable,
        bookDetailBuilder: BookDetailBuildable
    ) {
        self.bookDetailBuilder = bookDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToBookDetail(of isbn13: String) {
        let router = bookDetailBuilder.build(withListener: interactor, isbn13: isbn13)
        self.bookDetailRouting = router
        attachChild(router)
        viewController.pushViewController(router.viewControllable, animated: true)
    }
    
    func detachToBookDetail(_ animated: Bool) {
        guard let router = bookDetailRouting else { return }
        detachChild(router)
        viewController.popViewController(animated)
        bookDetailRouting = nil
    }
}

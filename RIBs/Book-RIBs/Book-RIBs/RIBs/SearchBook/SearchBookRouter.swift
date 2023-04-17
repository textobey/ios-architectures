//
//  SearchBookRouter.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs

protocol SearchBookInteractable: Interactable, BookDetailListener {
    var router: SearchBookRouting? { get set }
    var listener: SearchBookListener? { get set }
}

protocol SearchBookViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func pushViewController(_ viewController: ViewControllable, animated: Bool)
    func popViewController(_ animated: Bool)
}

final class SearchBookRouter: ViewableRouter<SearchBookInteractable, SearchBookViewControllable>, SearchBookRouting {
    
    private let bookDetailBuilder: BookDetailBuildable
    private var bookDetailRouting: ViewableRouting?

    init(
        interactor: SearchBookInteractable,
        viewController: SearchBookViewControllable,
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

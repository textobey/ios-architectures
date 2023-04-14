//
//  BookDetailRouter.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/14.
//

import RIBs

protocol BookDetailInteractable: Interactable {
    var router: BookDetailRouting? { get set }
    var listener: BookDetailListener? { get set }
}

protocol BookDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BookDetailRouter: ViewableRouter<BookDetailInteractable, BookDetailViewControllable>, BookDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: BookDetailInteractable, viewController: BookDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

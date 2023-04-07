//
//  SearchBookRouter.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs

protocol SearchBookInteractable: Interactable {
    var router: SearchBookRouting? { get set }
    var listener: SearchBookListener? { get set }
}

protocol SearchBookViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchBookRouter: ViewableRouter<SearchBookInteractable, SearchBookViewControllable>, SearchBookRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SearchBookInteractable, viewController: SearchBookViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

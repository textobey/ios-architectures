//
//  NewBookRouter.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs

protocol NewBookInteractable: Interactable {
    var router: NewBookRouting? { get set }
    var listener: NewBookListener? { get set }
}

protocol NewBookViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class NewBookRouter: ViewableRouter<NewBookInteractable, NewBookViewControllable>, NewBookRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: NewBookInteractable, viewController: NewBookViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToBookDetail(of isbn13: String) {
        
    }
}
 

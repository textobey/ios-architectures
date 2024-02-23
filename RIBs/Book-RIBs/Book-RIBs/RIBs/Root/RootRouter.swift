//
//  RootRouter.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/11.
//

import RIBs
import UIKit

protocol RootInteractable: Interactable, NewBookListener, SearchBookListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func setupTabBarController()
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    private let newBookBuilder: NewBookBuildable
    // ViewableRouting? RIB의 View 역할을 하는 ViewControllable이 정의되어 있다. router에서 UIViewController로 접근시 사용하는 프로토콜
    //private var newBookRouter: ViewableRouting?
    private var newBookRouter: (ViewableRouting?, NewBookActionableItem?)
    
    private let searchBookBuilder: SearchBookBuildable
    private var searchBookRouter: ViewableRouting?
    
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        newBookBuilder: NewBookBuildable,
        searchBookBuilder: SearchBookBuilder
    ) {
        self.newBookBuilder = newBookBuilder
        self.searchBookBuilder = searchBookBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        let tabs: [ViewControllable]  = [
            attachNewBookRIB(),
            attachSearchBookRIB()
        ]
        
        viewController.setupTabBarController()
        viewController.setViewControllers(
            tabs.map { $0.uiviewController },
            animated: false
        )
    }
    
    private func attachNewBookRIB() -> ViewControllable {
        // listener로 interactor를 전달하는 이유?
        let newBook = newBookBuilder.build(withListener: interactor)
        self.newBookRouter = newBook
        attachChild(newBook.router)
        return newBook.router.viewControllable
    }
    
    private func attachSearchBookRIB() -> ViewControllable {
        let router = searchBookBuilder.build(withListener: interactor)
        self.searchBookRouter = router
        attachChild(router)
        return router.viewControllable
    }
    
    // FIXME: 이미 존재하고 있는 RootView이기 때문에, route라는 네이밍이 이상하고 강제언래핑을 수정해야함
    func routeNewBook() -> NewBookActionableItem {
        return newBookRouter.1!
    }
}

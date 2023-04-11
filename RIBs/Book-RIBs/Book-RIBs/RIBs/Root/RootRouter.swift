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
    private var newBookRouter: ViewableRouting?
    
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
        let router = newBookBuilder.build(withListener: interactor)
        self.newBookRouter = router
        attachChild(router)
        return router.viewControllable
    }
    
    private func attachSearchBookRIB() -> ViewControllable {
        let router = searchBookBuilder.build(withListener: interactor)
        self.searchBookRouter = router
        attachChild(router)
        return router.viewControllable
    }
}

//
//  RootRouter.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs

protocol RootInteractable: Interactable, TabBarListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func pushViewController(_ viewController: ViewControllable, animated: Bool)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    private let tabBarBuilder: TabBarBuildable
    
    init(
        tabBarBuilder: TabBarBuildable,
        interactor: RootInteractable,
        viewController: RootViewControllable
    ) {
        self.tabBarBuilder = tabBarBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        attachTabBar()
    }
    
    private func attachTabBar() {
        let router = tabBarBuilder.build(withListener: interactor)
        attachChild(router)
        viewController.pushViewController(router.viewControllable, animated: false)
    }
}

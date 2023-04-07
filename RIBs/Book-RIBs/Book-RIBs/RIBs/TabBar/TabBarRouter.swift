//
//  TabBarRouter.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs
import UIKit

protocol TabBarInteractable: Interactable, NewBookListener, SearchBookListener {
    var router: TabBarRouting? { get set }
    var listener: TabBarListener? { get set }
}

protocol TabBarViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func setupTabBarController()
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool)
}

final class TabBarRouter: ViewableRouter<TabBarInteractable, TabBarViewControllable>, TabBarRouting {
    
    private let newBookBuilder: NewBookBuildable
    // ViewableRouting? RIB의 View 역할을 하는 ViewControllable이 정의되어 있다. router에서 UIViewController로 접근시 사용하는 프로토콜
    private var newBook: ViewableRouting?
    
    private let searchBookBuilder: SearchBookBuildable
    private var searchBook: ViewableRouting?
    
    init(
        interactor: TabBarInteractable,
        viewController: TabBarViewControllable,
        newBookBuilder: NewBookBuildable,
        searchBookBuilder: SearchBookBuildable
    ) {
        self.newBookBuilder = newBookBuilder
        self.searchBookBuilder = searchBookBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        setupNewBookViewController()
        setupSearchBookViewController()
        
        viewController.setupTabBarController()
        viewController.setViewControllers([
            newBook!.viewControllable.uiviewController,
            searchBook!.viewControllable.uiviewController
        ], animated: false)
    }
    
    private func setupNewBookViewController() {
        // listener로 interactor를 전달하는 이유?
        let newBook = newBookBuilder.build(withListener: interactor)
        self.newBook = newBook
        attachChild(newBook)
    }
    
    private func setupSearchBookViewController() {
        let searchBook = searchBookBuilder.build(withListener: interactor)
        self.searchBook = searchBook
        attachChild(searchBook)
    }
    
}

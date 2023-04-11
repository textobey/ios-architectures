//
//  RootTabBarController.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/11.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootTabBarViewController: UITabBarController, RootViewControllable, RootPresentable {

    weak var listener: RootPresentableListener?
    
    private var tabBarItems: [UITabBarItem] {
        return self.fetchTabBarItems()
    }
    
    private var titles: [String] {
        return self.fetchNavigationBarTitles()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        let rootViewControllers = zip(viewControllers, tabBarItems)
            .map { rootViewController, tabBarItem -> UIViewController in
                rootViewController.view.backgroundColor = .systemBackground
                rootViewController.tabBarItem = tabBarItem
                return rootViewController
            }
        
        let navigationControllers = createNavigationControllers(rootViewControllers)
        //super.setViewControllers(navigationControllers, animated: animated)
        self.viewControllers = navigationControllers
    }
    
    func setupTabBarController() {
        self.selectedIndex = 0
        self.view.backgroundColor = .white
        self.tabBar.isTranslucent = true
        self.tabBar.backgroundColor = .systemGroupedBackground
    }
    
    private func createNavigationControllers(_ viewControllers: [UIViewController]) -> [UINavigationController] {
        return zip(viewControllers, titles).map { rootViewController, title -> UINavigationController in
            return UINavigationController(rootViewController: rootViewController).then {
                $0.navigationBar.prefersLargeTitles = true
                $0.navigationBar.topItem?.title = title
            }
        }
    }
    
    private func fetchTabBarItems() -> [UITabBarItem] {
        return [
            UITabBarItem(title: "New", image: UIImage(systemName: "book"), tag: 0),
            UITabBarItem(tabBarSystemItem: .search, tag: 1)
        ]
    }
    
    private func fetchNavigationBarTitles() -> [String] {
        return ["New Books", "Search Books"]
    }
}

//
//  TabBarViewController.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs
import RxSwift
import UIKit

protocol TabBarPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class TabBarViewController: UITabBarController, TabBarPresentable, TabBarViewControllable {

    weak var listener: TabBarPresentableListener?
    
    private var tabBarItems: [UITabBarItem] {
        return self.fetchTabBarItems()
    }
    
    private var titles: [String] {
        return self.fetchNavigationBarTitles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        let rootViewControllers = zip(viewControllers, tabBarItems)
            .map { rootViewController, tabBarItem -> UINavigationController in
                rootViewController.view.backgroundColor = .systemBackground
                rootViewController.tabBarItem = tabBarItem
                
                return UINavigationController(rootViewController: rootViewController).then {
                    $0.navigationBar.prefersLargeTitles = true
                    $0.navigationBar.topItem?.title = tabBarItem.title
                }
            }
        super.setViewControllers(rootViewControllers, animated: animated)
    }
    
    func setupTabBarController() {
        self.selectedIndex = 0
        self.view.backgroundColor = .white
        self.tabBar.isTranslucent = true
        self.tabBar.backgroundColor = .systemGroupedBackground
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

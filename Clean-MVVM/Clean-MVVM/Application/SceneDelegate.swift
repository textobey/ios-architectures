//
//  SceneDelegate.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/13/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let coreDIContainer = CoreDIContainer()
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window?.windowScene = windowScene
        window?.rootViewController = createRootViewController()
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    private func createRootViewController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let bookDIContainer = BookDIContainer(coreDIContainer: coreDIContainer)
        
        let newBookViewModel = NewBookViewModel(bookDIContainer: bookDIContainer)
        let newBookViewController = NewBookViewController(viewModel: newBookViewModel)
        
        let searchBookViewController = SearchBookViewController()
        
        newBookViewController.tabBarItem = UITabBarItem(title: "New", image: UIImage(systemName: "book"), tag: 0)
        searchBookViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let navigationControllers = [
            UINavigationController(rootViewController: newBookViewController),
            UINavigationController(rootViewController: searchBookViewController)
        ]
        
        tabBarController.setViewControllers(navigationControllers, animated: false)
        
        return tabBarController
    }
}


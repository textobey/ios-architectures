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
        
        let tabBarController = UITabBarController()
        
        let newBookScene = UINavigationController(rootViewController: UIViewController())
        let searchBookScene = UINavigationController(rootViewController: UIViewController())
        
        newBookScene.tabBarItem = UITabBarItem(title: "NewBook", image: UIImage(systemName: "book"), tag: 0)
        searchBookScene.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "book"), tag: 1)
        
        tabBarController.setViewControllers([newBookScene, searchBookScene], animated: false)
        
        tabBarController.viewControllers?.forEach {
            $0.view.backgroundColor = .white
        }
        
        window?.windowScene = windowScene
        window?.rootViewController = tabBarController
//        window?.rootViewController = ViewController(
//            bookDIContainer: BookDIContainer(coreDIContainer: coreDIContainer)
//        )
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    
    private func createRootViewController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let newBookScene = UINavigationController(rootViewController: UIViewController())
        let searchBookScene = UINavigationController(rootViewController: UIViewController())
        
        newBookScene.tabBarItem = UITabBarItem(title: "NewBook", image: UIImage(systemName: "book"), tag: 0)
        searchBookScene.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "book"), tag: 1)
        
        tabBarController.setViewControllers([newBookScene, searchBookScene], animated: false)
    }
}


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
        window?.rootViewController = ViewController(
            bookDIContainer: BookDIContainer(coreDIContainer: coreDIContainer)
        )
        window?.makeKeyAndVisible()
    }
}


//
//  SceneDelegate.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/06.
//

import UIKit
import RIBs
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var launchRoter: LaunchRouting?
    private var urlHandler: UrlHandler?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let appComponent = AppComponent()
        let result = RootBuilder(dependency: appComponent).build()
        self.urlHandler = result.urlHandler
        self.launchRoter = result.launchRouter
        self.launchRoter?.launch(from: window!)
        window?.backgroundColor = .systemBackground
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        urlHandler?.handle(url)
    }
}

protocol UrlHandler: AnyObject {
    func handle(_ url: URL)
}

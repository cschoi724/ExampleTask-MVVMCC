//
//  SceneDelegate.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController()
        nav.isNavigationBarHidden = true
        self.mainCoordinator = ImpMainCoordinator(nav)
        self.mainCoordinator?.start()
        self.window?.windowLevel = .normal
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
}


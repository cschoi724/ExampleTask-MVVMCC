//
//  AppDelegate.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/10.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var appContainer: AppContainer!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.appContainer = ImpAppContainer()
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}


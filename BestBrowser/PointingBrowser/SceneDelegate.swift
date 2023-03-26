//
//  SceneDelegate.swift
//  BestBrowser
//
//  Created by yangjian on 2023/3/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        AppUtil.shared.appdelegate = self
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        window?.rootViewController = AppUtil.shared.launch
        AppUtil.shared.launching()
        if AppUtil.shared.selectIndex == 1 {
            // hot launch
            FirebaseUtil.log(event: .openHot)
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        AppUtil.shared.selectIndex = 1
    }


}


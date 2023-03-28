//
//  SceneDelegate.swift
//  BestBrowser
//
//  Created by yangjian on 2023/3/24.
//

import UIKit
import Firebase
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        AppUtil.shared.appdelegate = self
        if let url = connectionOptions.urlContexts.first?.url {
            ApplicationDelegate.shared.application(
                    UIApplication.shared,
                    open: url,
                    sourceApplication: nil,
                    annotation: [UIApplication.OpenURLOptionsKey.annotation]
                )
        }
        FirebaseApp.configure()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        window?.rootViewController = AppUtil.shared.launch
        if AppUtil.shared.selectIndex == 1 {
            // hot launch
            FirebaseUtil.log(event: .openHot)
        }
        AppUtil.shared.launching()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        AppUtil.shared.selectIndex = 1
    }


}


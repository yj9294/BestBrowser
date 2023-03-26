//
//  AppUtil.swift
//  BestBrowser
//
//  Created by yangjian on 2023/3/24.
//

import Foundation

class AppUtil: NSObject {
    static let shared = AppUtil()
    
    var enterbackground: Bool = false
    var appdelegate: SceneDelegate? = nil
    var launch = LaunchVC()
    var home = HomeVC()
    var selectIndex = 0
    
    func launched() {
        selectIndex = 1
        appdelegate?.window?.rootViewController = home
    }
    
    func launching() {
        selectIndex = 0
        appdelegate?.window?.rootViewController = launch
        launch.launch()
    }
}

extension String {
    
    var isUrl: Bool {
        let url = "[a-zA-z]+://.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
    }
    
}

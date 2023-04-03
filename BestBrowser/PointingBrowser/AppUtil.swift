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

extension UserDefaults {
    func setModel<T: Encodable> (_ object: T?, forKey key: String) {
        let encoder =  JSONEncoder()
        guard let object = object else {
            self.removeObject(forKey: key)
            return
        }
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        
        self.setValue(encoded, forKey: key)
    }
    
    func model<T: Decodable> (_ type: T.Type, forKey key: String) -> T? {
        guard let data = self.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            print("Could'n find key")
            return nil
        }
        
        return object
    }
}

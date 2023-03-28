//
//  FIrebaseUtil.swift
//  PointingBrowser
//
//  Created by yangjian on 2023/3/25.
//

import Foundation
import Firebase

class FirebaseUtil: NSObject {
    static func log(event: AnaEvent, params: [String: Any]? = nil) {
        
        if event.first {
            if UserDefaults.standard.bool(forKey: event.rawValue) == true {
                return
            } else {
                UserDefaults.standard.set(true, forKey: event.rawValue)
            }
        }
        
        #if DEBUG
        #else
        Analytics.logEvent(event.rawValue, parameters: params)
        #endif
        
        NSLog("[Event] \(event.rawValue) \(params ?? [:])")
    }
    
    static func log(property: AnaProperty, value: String? = nil) {
        
        var value = value
        
        if property.first {
            if UserDefaults.standard.string(forKey: property.rawValue) != nil {
                value = UserDefaults.standard.string(forKey: property.rawValue)!
            } else {
                UserDefaults.standard.set(Locale.current.regionCode ?? "us", forKey: property.rawValue)
            }
        }
#if DEBUG
#else
        Analytics.setUserProperty(value, forName: property.rawValue)
#endif
        NSLog("[Property] \(property.rawValue) \(value ?? "")")
    }
}

enum AnaProperty: String {
    /// 設備
    case local = "ay_ui"
    
    var first: Bool {
        switch self {
        case .local:
            return true
        }
    }
}

enum AnaEvent: String {
    
    var first: Bool {
        switch self {
        case .open:
            return true
        default:
            return false
        }
    }
    
    case open = "lun_ui"
    case openCold = "er_ui"
    case openHot = "ew_ui"
    case homeShow = "eq_ui"
    case navigaClick = "ws_ui"
    case navigaSearch = "wa_ui"
    case cleanClick = "bu_ui"
    case cleanSuccess = "xian_ui"
    case cleanAlert = "dd_ui"
    case listShow = "dl_ui"
    case newAction = "acv_ui"
    case shareClick = "xmo_ui"
    case copyClick = "qws_ui"
    case webStart = "zxc_ui"
    case webSuccess = "bnm_ui"
}

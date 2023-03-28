//
//  HomeVC.swift
//  BestBrowser
//
//  Created by yangjian on 2023/3/24.
//

import UIKit
import AppTrackingTransparency
import WebKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tabButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var date: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        Task{
            if !Task.isCancelled {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                ATTrackingManager.requestTrackingAuthorization(){ _ in }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshStatus()
        BrowserUtil.shared.addedWebView(from: view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        BrowserUtil.shared.removeWebView()
        FirebaseUtil.log(event: .homeShow)
    }
    
    override func viewDidLayoutSubviews() {
        BrowserUtil.shared.frame = contentView.frame
    }

}

extension HomeVC {
    
    @IBAction func searchAction() {
        view.endEditing(true)
        if let text = textField.text, text.count > 0 {
            BrowserUtil.shared.loadUrl(text, from: self)
            FirebaseUtil.log(event: .navigaSearch, params: ["lig": text])
        } else {
            alert("Please enter your search content.")
        }
    }
    
    @IBAction func searchButton(btn: UIButton) {
        let item = HomeItem.allCases[btn.tag]
        BrowserUtil.shared.loadUrl(item.url, from: self)
        FirebaseUtil.log(event: .navigaClick, params: ["lib": item.rawValue])
    }
    
    @IBAction func stopSearchAction() {
        view.endEditing(true)
        BrowserUtil.shared.stopLoad()
        textField.text = ""
    }
    
    @IBAction func lastAction() {
        BrowserUtil.shared.goBack()
    }
    
    @IBAction func nextAction() {
        BrowserUtil.shared.goForword()
    }
    
    @IBAction func cleanAction() {
        let clean = CleanView()
        self.view.window?.addSubview(clean)
        clean.frame = self.view.bounds
        clean.certainHanle = {
            let vc = CleanVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            vc.handle = {
                self.refreshStatus()
                self.alert("Cleaned!")
                FirebaseUtil.log(event: .cleanAlert)
            }
        }
        
        FirebaseUtil.log(event: .cleanClick)
    }
    
    @IBAction func tabAction() {
        let vc = BrowserListVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func settingAction() {
        let setting = SettingView()
        self.view.window?.addSubview(setting)
        setting.frame = self.view.bounds
        setting.newHandle = {
            self.refreshStatus()
        }
        setting.privacyHandle = {
            let vc = TermsVC()
            vc.content = """
Information collection
We collect and use data in strict accordance with this privacy policy. We will regularly learn about laws and regulations, and collect and use data in strict accordance with legal provisions.
We will not read your exact location information, nor will we read your sensitive privacy. Won't collect apps from your phone.
Usage data: including but not limited to the type of mobile device, IP address of the mobile device, mobile operating system, type of mobile internet browser you are using, device identifier, and other diagnostic data.
Information sent when accessing the service: including but not limited to the email address you use to contact us, and information that can be used to contact or identify you personally.
Information usage
Used to update and maintain this application.
To analyze the download and usage of applications in order to provide better service.
For advertising and marketing purposes.
Information sharing
We do have third-party service providers and partners who may collect information about you. We are not responsible for the actions of these third parties. If you prefer, please familiarize yourself with their privacy policy.
We will disclose your information when required by law
We will disclose your information when our business is transferred, sold, restructured, or merged.
Children's Privacy
We only serve the 17+ age group. If a group of people over 17 years old uses our services and provides information, please ask the guardian to contact us even though, we will promptly take necessary measures including removing the relevant information.
"""
            vc.tit = "Privacy Policy"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        setting.termsHandle = {
            let vc = TermsVC()
            vc.content = """
Use of the application
1. Do not use this product for any unauthorized commercial purposes.
2. Do not use this product for any illegal purpose.


Update
We may update this page from time to time. We recommend that you check this page regularly for updates.
Contact us
If you have any questions about this Privacy Policy, please contact us
Ning81731877@outlook.com
"""
            vc.tit = "Terms of Use"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    func refreshStatus() {
        stopButton.isHidden = !BrowserUtil.shared.isLoading
        searchButton.isHidden = BrowserUtil.shared.isLoading
        tabButton.setTitle("\(BrowserUtil.shared.count)", for: .normal)
        textField.text = BrowserUtil.shared.url
        progressView.progress = Float(BrowserUtil.shared.progrss)
        nextButton.isEnabled = BrowserUtil.shared.canGoForword
        lastButton.isEnabled = BrowserUtil.shared.canGoBack
        BrowserUtil.shared.delegate = self
        BrowserUtil.shared.uiDelegate = self
        if BrowserUtil.shared.progrss > 0, BrowserUtil.shared.progrss < 1.0 {
            progressView.isHidden = false
        } else {
            progressView.isHidden = true
        }
        if BrowserUtil.shared.url == nil  {
            BrowserUtil.shared.removeWebView()
        }
        if BrowserUtil.shared.progrss == 0.1 {
            date = Date()
            FirebaseUtil.log(event: .webStart)
        }
        
        if BrowserUtil.shared.progrss == 1.0 {
            let time = Date().timeIntervalSince1970 - date.timeIntervalSince1970
            FirebaseUtil.log(event: .webSuccess, params: ["lig": "\(ceil(time))"])
            stopButton.isHidden = true
            searchButton.isHidden = false
        }
    }
    
}

extension HomeVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {
            self.refreshStatus()
        }
    }
    
}

extension HomeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAction()
        return true
    }
}

extension HomeVC: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        /// 打开新的窗口
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward

        webView.load(navigationAction.request)
        
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return nil
    }
    
}

enum HomeItem: String, CaseIterable{
    case google, facebook, twitter, youtube, instagram, amazon, tiktok, yahoo
    var url: String {
        return "https://www.\(self.rawValue).com"
    }
}


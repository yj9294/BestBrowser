//
//  LaunchVC.swift
//  BestBrowser
//
//  Created by yangjian on 2023/3/24.
//

import UIKit

class LaunchVC: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    private var timer: DispatchSourceTimer? = nil
    
    private var progress: Float = 0.0 {
        didSet {
            progressView.progress = progress
            if progress > 1.0 {
                timer?.cancel()
                timer = nil
                GADUtil.share.show(.interstitial) { [weak self] _ in
                    self?.lauched()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseUtil.log(property: .local)
        FirebaseUtil.log(event: .open)
        FirebaseUtil.log(event: .openCold)
    }
    
    
    public func launch() {
        
        if timer != nil {
            timer?.cancel()
            timer = nil
        }
        
        progress = 0
        var duration = 15.0
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: 0.01)
        timer?.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.progress += Float((0.01 / duration))
            }
            // 延时 0.4
            if (self?.progress ?? 0) > 1 / 15.0 * 0.2 {
                if GADUtil.share.isLoaded(.interstitial) {
                    duration = 1.0
                }
            }
        }
        timer?.resume()
        
        GADUtil.share.load(.interstitial)
        GADUtil.share.load(.native)
    }
    
    public func lauched() {
        AppUtil.shared.launched()
    }

}

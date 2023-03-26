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
                lauched()
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
        
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: 0.01)
        timer?.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.progress += (0.01 / 2.5)
            }
        }
        timer?.resume()
    }
    
    public func lauched() {
        AppUtil.shared.launched()
    }

}

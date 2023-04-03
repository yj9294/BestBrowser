//
//  CleanVC.swift
//  PointingBrowser
//
//  Created by yangjian on 2023/3/25.
//

import UIKit

class CleanVC: UIViewController {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    
    var handle: (()->Void)? = nil
    
    var progress: Float = 0.0 {
        didSet {
            self.view.updateConstraintsIfNeeded()
            heightConstraint.constant = CGFloat(progress * 218)
            label.text = "\(Int(progress * 100))%"
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
            if progress > 1.0 {
                timer.cancel()
                FirebaseUtil.log(event: .cleanSuccess)
                GADUtil.share.show(.interstitial, from: self) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                        self.dismiss(animated: true) { [weak self] in
                            self?.handle?()
                        }
                    }
                }
            }
        }
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now(), repeating: 0.01)
        var duration = 15.6
        timer.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.progress += Float((0.01 / duration))
            }
            
            // 延时 0.4
            if (self?.progress ?? 0) > (1 / 15.0 * 0.2) {
                if GADUtil.share.isLoaded(.interstitial) {
                    duration = 1.0
                }
            }
        }
        return timer
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer.resume()
        BrowserUtil.shared.clean(from: self)
        GADUtil.share.load(.interstitial)
        GADUtil.share.load(.native)
    }

}

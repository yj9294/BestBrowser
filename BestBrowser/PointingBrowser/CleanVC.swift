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
                self.dismiss(animated: true) { [weak self] in
                    self?.handle?()
                }
            }
        }
    }
    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now(), repeating: 0.01)
        timer.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.progress += (0.01 / 2.5)
            }
        }
        return timer
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer.resume()
        BrowserUtil.shared.clean(from: self)
    }

}

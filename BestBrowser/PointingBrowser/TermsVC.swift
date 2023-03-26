//
//  TermsVC.swift
//  BestBrowser
//
//  Created by yangjian on 2023/3/25.
//

import UIKit

class TermsVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var content: String = ""
    var tit: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = tit
        self.textView.text = content
    }

    @IBAction func backAction() {
        self.dismiss(animated: true)
    }
}

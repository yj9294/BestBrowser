//
//  CleanView.swift
//  BestBrowser
//
//  Created by yangjian on 2023/3/25.
//

import UIKit

class CleanView: UIView {
    
    var certainHanle: (()->Void)? = nil

    lazy var button: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(removeFromSuperview), for: .touchUpInside)
        return btn
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "#292E37")
        view.cornerRadius = 8
        return view
    }()

    lazy var icon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "clean_1"))
        return view
    }()

    lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Close Tabs and Clear Data"
        return label
    }()

    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = UIColor(named: "#343942")
        button.setTitleColor(UIColor(named: "#8895AB"), for: .normal)
        button.addTarget(self, action: #selector(removeFromSuperview), for: .touchUpInside)
        button.cornerRadius = 20
        return button
    }()

    lazy var certainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = UIColor(named: "#3F7CEC")
        button.setTitleColor(.white, for: .normal)
        button.cornerRadius = 20
        button.addTarget(self, action: #selector(certainAction), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        button.frame = self.bounds
        contentView.frame = CGRect(x: 24, y: self.bounds.height - 183 - 40 , width: self.bounds.width - 48, height: 183)
        icon.frame = CGRect(x: (contentView.bounds.width - 55) / 2.0, y: 18, width: 55, height: 55)
        title.frame = CGRect(x: (contentView.bounds.width - 200) / 2.0, y: icon.frame.maxY + 10, width: 200, height: 20)
        cancelButton.frame = CGRect(x: 32, y: title.frame.maxY + 16, width: 120, height: 40)
        certainButton.frame = CGRect(x: contentView.bounds.width - 120 - 32, y: cancelButton.frame.minY, width: 120, height: 40)
    }
    
    @objc func certainAction() {
        self.removeFromSuperview()
        certainHanle?()
    }
}

extension CleanView {
    
    func setupUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(button)
        addSubview(contentView)
        contentView.addSubview(icon)
        contentView.addSubview(title)
        contentView.addSubview(cancelButton)
        contentView.addSubview(certainButton)
    }
}

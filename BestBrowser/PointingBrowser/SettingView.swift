//
//  SettingView.swift
//  BestBrowser
//
//  Created by yangjian on 2023/3/25.
//

import UIKit
import MobileCoreServices

class SettingView: UIView {
    
    var newHandle: (()->Void)? = nil
    
    var privacyHandle: (()->Void)? = nil
    
    var termsHandle: (()->Void)? = nil
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "#292E37")
        view.cornerRadius = 8
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SettingCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(SettingCell.classForCoder()))
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var termButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "terms"), for: .normal)
        button.addTarget(self, action: #selector(termsAction), for: .touchUpInside)
        return button
    }()
    
    lazy var privacyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "privacy"), for: .normal)
        button.addTarget(self, action: #selector(privacyAction), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    override func layoutSubviews() {
        button.frame = window?.bounds ?? .zero
        contentView.frame = CGRect(x: 24, y: ((window?.bounds.height ?? 667) - 130 - 80), width: (window?.bounds.width ?? 375.0) - 48, height: 130)
        collectionView.frame = CGRect(x: 30, y: 22, width: contentView.bounds.width - 60, height: 52.0)
        termButton.frame = CGRect(x: 30, y: 94, width: 70, height: 11)
        privacyButton.frame = CGRect(x: termButton.frame.maxX + 17, y: termButton.frame.minY, width: 63, height: 11)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(button)
        addSubview(contentView)
        contentView.addSubview(collectionView)
        contentView.addSubview(privacyButton)
        contentView.addSubview(termButton)
    }
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }
    
    @objc func privacyAction() {
        self.removeFromSuperview()
        privacyHandle?()
    }
    
    @objc func termsAction() {
        self.removeFromSuperview()
        termsHandle?()
    }
    
}

extension SettingView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        SettingItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(SettingCell.classForCoder()), for: indexPath)
        if let cell = cell as? SettingCell {
            cell.item = SettingItem.allCases[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 26, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = SettingItem.allCases[indexPath.row]
        if item == .new {
            self.removeFromSuperview()
            BrowserUtil.shared.removeWebView()
            BrowserUtil.shared.add()
            GADUtil.share.close(.native)
            Task {
                if !Task.isCancelled {
                    try await Task.sleep(nanoseconds: 500_000)
                    newHandle?()
                }
            }
            
            FirebaseUtil.log(event: .newAction, params: ["lig": "setting"])
        } else if item == .share {
            self.removeFromSuperview()
            var url = "https://itunes.apple.com/cn/app/id6446871195"
            if !BrowserUtil.shared.item.isNavigation, let text = BrowserUtil.shared.item.webView.url?.absoluteString {
                url = text
            }
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            AppUtil.shared.appdelegate?.window?.rootViewController?.present(vc, animated: true)
            FirebaseUtil.log(event: .shareClick)
        } else if item == .copy {
            self.removeFromSuperview()
            if !BrowserUtil.shared.item.isNavigation, let text = BrowserUtil.shared.item.webView.url?.absoluteString {
                UIPasteboard.general.setValue(text, forPasteboardType: kUTTypePlainText as String)
                AppUtil.shared.appdelegate?.window?.rootViewController?.alert("Copy successed.")
            } else {
                UIPasteboard.general.setValue("", forPasteboardType: kUTTypePlainText as String)
                AppUtil.shared.appdelegate?.window?.rootViewController?.alert("Copy successed.")
            }
            FirebaseUtil.log(event: .copyClick)
        } else if item == .rate {
            self.removeFromSuperview()
            if let url = URL(string: "https://itunes.apple.com/cn/app/id6446871195") {
                UIApplication.shared.open(url)
            }
        }
    }
    
}

class SettingCell: UICollectionViewCell {
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        icon.frame = CGRect(x: ((self.bounds.width) - 26) / 2.0, y: 0, width: 26, height: 26)
        title.frame = CGRect(x: ((self.bounds.width) - 50) / 2.0, y: icon.frame.maxY + 6, width: 50, height: 20)
    }
    
    func setupUI(){
        addSubview(icon)
        addSubview(title)
    }
    
    var item: SettingItem = .new {
        didSet {
            icon.image = UIImage(named: item.rawValue)
            title.text = item.title
        }
    }
}

enum SettingItem: String, CaseIterable {
    case new, share, copy, rate
    var title: String {
        switch self {
        case .new:
            return "New"
        case .share:
            return "Share"
        case .copy:
            return "Copy"
        case .rate:
            return "Rate Us"
        }
    }
}

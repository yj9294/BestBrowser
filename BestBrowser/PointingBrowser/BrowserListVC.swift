//
//  BrowserListVC.swift
//  BestBrowser
//
//  Created by yangjian on 2023/3/24.
//

import UIKit

class BrowserListVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var adView: GADNativeView!
    var willAppear: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotifications()
        collectionView.register(BrowserListCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(BrowserListCell.classForCoder()))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FirebaseUtil.log(event: .listShow)
        willAppear = true
        GADUtil.share.load(.interstitial)
        GADUtil.share.load(.native)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        willAppear = false
        GADUtil.share.close(.native)
    }
    
    @IBAction func backAction() {
        self.dismiss(animated: true)
    }
    
    @IBAction func newAction() {
        BrowserUtil.shared.add()
        self.dismiss(animated: true)
        FirebaseUtil.log(event: .newAction, params: ["lig": "tab"])
    }
    
    func addNotifications() {
        NotificationCenter.default.addObserver(forName: .nativeUpdate, object: nil, queue: .main) { [weak self] noti in
            if let ad = noti.object as? NativeADModel, self?.willAppear == true {
                if Date().timeIntervalSince1970 - (GADUtil.share.tabNativeAdImpressionDate ?? Date(timeIntervalSinceNow: -11)).timeIntervalSince1970 > 10 {
                    self?.adView.nativeAd = ad.nativeAd
                    GADUtil.share.tabNativeAdImpressionDate = Date()
                } else {
                    NSLog("[ad] 10s tab 原生广告刷新或数据填充间隔.")
                }
            } else {
                self?.adView.nativeAd = nil
            }
        }
    }

}

extension BrowserListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BrowserUtil.shared.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(BrowserListCell.classForCoder()), for: indexPath)
        if let cell = cell as? BrowserListCell {
            cell.item = BrowserUtil.shared.items[indexPath.row]
            cell.closeHandle = { [weak self] in
                BrowserUtil.shared.remove(cell.item)
                self?.collectionView.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (( view.window?.bounds.width ?? 375) - 32) / 2.0, height: 235)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        BrowserUtil.shared.select(BrowserUtil.shared.items[indexPath.row])
        self.dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


class BrowserListCell: UICollectionViewCell {
    
    var closeHandle: (()->Void)? = nil
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        button.setImage(UIImage(named: "close"), for: .normal)
        return button
    }()
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "launch_logo")
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRect(x: 15, y: 8, width: self.bounds.width - 60, height: 20)
        closeButton.frame = CGRect(x: title.frame.maxX + 10, y: 8, width: 40, height: 40)
        icon.frame = CGRect(x: (self.bounds.width - 110) / 2.0 , y: (self.bounds.height - 75 ) / 2.0, width: 110, height: 75)
    }
    
    var item: BrowserItem = .navgationItem {
        didSet {
            if item.isSelect {
                self.backgroundColor = UIColor(named: "Color") ?? .black
            } else {
                self.backgroundColor = .gray
            }
            
            if BrowserUtil.shared.count == 1 {
                closeButton.isHidden = true
            } else {
                closeButton.isHidden = false
            }
            
            title.text = item.webView.url?.absoluteString
        }
    }
    
    @objc func closeAction() {
        closeHandle?()
    }
    
    func setupUI() {
        self.addSubview(title)
        self.addSubview(closeButton)
        self.addSubview(icon)
        self.borderWidth = 1
        self.cornerRadius = 12
    }
}

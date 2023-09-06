//
//  LobbyViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class LobbyViewController: STBaseViewController {
    
    private let trackingProvider = TrackingProvider()
    
    private var cid: String?
    
    private var memberID: String?
    
    private var eventDate: String?
    
    private var eventTimestamp: Int?

    @IBOutlet weak var lobbyView: LobbyView! {
        didSet {
            lobbyView.delegate = self
        }
    }

    private var datas: [PromotedProducts] = [] {
        didSet {
            lobbyView.reloadData()
        }
    }

    private let marketProvider = MarketProvider()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = UIImageView(image: .asset(.Image_Logo02))
        
        lobbyView.beginHeaderRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postTrackingEventView()
    }
    
    // MARK: - Action
    
    private func postTrackingEventView() {
        print("進入hots, style \(UserDataManager.shared.style)")
        if let cid = UserDataManager.shared.cid {
            self.cid = cid
        } else {
            let newUUID = UUID()
            let cidString = newUUID.uuidString
            UserDataManager.shared.cid = cidString
            self.cid = cidString
        }
        
        if let memberID = UserDataManager.shared.memberID {
            self.memberID = memberID
        }
        
        configureEventDate()
        configureEventTimestamp()
        
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "view", eventValue: "hots", splitTesting: "fresh") { result in
            switch result {
                case .success:
                    print("cid: \(self.cid), memberID: \(self.memberID), eventDate: \(self.eventDate), eventTimestamp: \(self.eventTimestamp)")
                    print("Tracking event success.")
                case .failure(let error):
                    print("Tracking event error: \(error)")
            }
        }
    }
    
    func configureEventDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        eventDate = formattedDate
    }
    
    func configureEventTimestamp() {
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        eventTimestamp = currentTimestamp
    }
    
    private func postTrackingEventClick() {
        print("點擊hots商品")
        if let cid = UserDataManager.shared.cid {
            self.cid = cid
        } else {
            let newUUID = UUID()
            let cidString = newUUID.uuidString
            UserDataManager.shared.cid = cidString
            self.cid = cidString
        }
        
        if let memberID = UserDataManager.shared.memberID {
            self.memberID = memberID
        }
        
        configureEventDate()
        configureEventTimestamp()
        // swiftlint:disable:next line_length
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "click", eventValue: "tinder_product_image", splitTesting: "fresh") { result in
            switch result {
                case .success:
                    print("Tracking event success.")
                case .failure(let error):
                    print("Tracking event error: \(error)")
            }
        }
    }
    
    private func fetchData() {
        marketProvider.fetchHots(completion: { [weak self] result in
            switch result {
            case .success(let products):
                self?.datas = products
            case .failure:
                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
    }
}

extension LobbyViewController: LobbyViewDelegate {
    
    func triggerRefresh(_ lobbyView: LobbyView) {
        fetchData()
    }

    // MARK: - UITableViewDataSource and UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[section].products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: LobbyTableViewCell.self),
            for: indexPath
        )
        guard let lobbyCell = cell as? LobbyTableViewCell else { return cell }
        
        lobbyCell.isAccessibilityElement = true
        lobbyCell.accessibilityIdentifier = "HotsCell_\(indexPath.row)"
        lobbyCell.accessibilityLabel = "HotsCell_\(indexPath.row)"
        
        let product = datas[indexPath.section].products[indexPath.row]
        if indexPath.row % 2 == 0 {
            lobbyCell.singlePage(
                img: product.mainImage,
                title: product.title,
                description: product.description
            )
        } else {
            lobbyCell.multiplePages(
                imgs: product.images,
                title: product.title,
                description: product.description
            )
        }
        return lobbyCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 67.0 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 258.0 }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 0.01 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: LobbyTableViewHeaderView.self)
            ) as? LobbyTableViewHeaderView else {
                return nil
        }
        headerView.titleLabel.text = datas[section].title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postTrackingEventClick()
        guard
            let detailVC = UIStoryboard.product.instantiateViewController(
                withIdentifier: String(describing: ProductDetailViewController.self)
            ) as? ProductDetailViewController
        else {
            return
        }
        detailVC.product = datas[indexPath.section].products[indexPath.row]
        show(detailVC, sender: nil)
    }
}

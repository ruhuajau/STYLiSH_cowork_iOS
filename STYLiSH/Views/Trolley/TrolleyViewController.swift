//
//  TrolleyViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/28.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class TrolleyViewController: STBaseViewController {

    private let trackingProvider = TrackingProvider()
    
    private var cid: String?
    
    private var memberID: String?
    
    private var eventDate: String?
    
    private var eventTimestamp: Int?
    
    private struct Segue {
        static let checkout = "SegueCheckout"
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    @IBOutlet weak var emptyView: UIView!

    @IBOutlet weak var checkoutBtn: UIButton!

    private var orders: [LSOrder] = [] {
        didSet {
            tableView.reloadData()
            if orders.count == 0 {
                tableView.isHidden = true
                checkoutBtn.isEnabled = false
                checkoutBtn.backgroundColor = .B4
            } else {
                tableView.isHidden = false
                checkoutBtn.isEnabled = true
                checkoutBtn.backgroundColor = .B1
            }
        }
    }
    
    private var observation: NSKeyValueObservation?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.lk_registerCellWithNib(identifier: String(describing: TrolleyTableViewCell.self), bundle: nil)

        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postTrackingEvent()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        StorageManager.shared.save()
    }
    
    // MARK: - Action
    private func postTrackingEvent() {
        print("進入購物車")
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
        
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "view", eventValue: "cart", splitTesting: "fresh") { result in
            switch result {
                case .success:
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
        print("點擊結帳")
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
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "click", eventValue: "checkout", splitTesting: "fresh") { result in
            switch result {
                case .success:
                    print("Tracking event success.")
                case .failure(let error):
                    print("Tracking event error: \(error)")
            }
        }
    }
    
    private func fetchData() {
        observation = StorageManager.shared.observe(
            \.orders,
            options: [.initial, .new],
            changeHandler: { [weak self] (_, value) in
                guard let datas = value.newValue else { return }
                self?.orders = datas
            }
        )
    }

    private func deleteData(at index: Int) {
        StorageManager.shared.deleteOrder(
            orders[index],
            completion: { result in
                switch result {
                case .success: break
                case .failure: LKProgressHUD.showFailure(text: "刪除資料失敗！")
                }
            }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.checkout {
            guard let checkoutVC = segue.destination as? CheckoutViewController else { return }
            let orderProvider = OrderProvider(order: Order(products: orders))
            checkoutVC.orderProvider = orderProvider
        }
    }
}

extension TrolleyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TrolleyTableViewCell.self),
            for: indexPath
        )
        guard let trolleyCell = cell as? TrolleyTableViewCell else { return cell }
        trolleyCell.layoutView(order: orders[indexPath.row])
        trolleyCell.touchHandler = { [weak self] in
            self?.deleteData(at: indexPath.row)
        }
        trolleyCell.valueChangeHandler = { [weak self] value in
            self?.orders[indexPath.row].amount = value.int64()
        }
        return trolleyCell
    }
}

extension TrolleyViewController: UITableViewDelegate {}

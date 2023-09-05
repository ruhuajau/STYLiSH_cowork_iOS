//
//  ProductDetailViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/2.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class ProductDetailViewController: STBaseViewController {
    
    private let trackingProvider = TrackingProvider()
    
    private var cid: String?
    
    private var memberID: String?
    
    private var eventDate: String?
    
    private var eventTimestamp: Int?

    private struct Segue {
        static let picker = "SeguePicker"
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }

    @IBOutlet weak var galleryView: LKGalleryView! {
        didSet {
            galleryView.frame.size.height = CGFloat(Int(UIScreen.width / 375.0 * 500.0))
            galleryView.delegate = self
        }
    }

    @IBOutlet weak var productPickerView: UIView!

    @IBOutlet weak var addToCarBtn: UIButton!
    
    @IBOutlet weak var baseView: UIView!

    private lazy var blurView: UIView = {
        let blurView = UIView(frame: tableView.frame)
        blurView.backgroundColor = .black.withAlphaComponent(0.4)
        return blurView
    }()

    private let datas: [ProductContentCategory] = [
        .description, .color, .size, .stock, .texture, .washing, .placeOfProduction, .remarks
    ]

    var product: Product? {
        didSet {
            guard let product = product, let galleryView = galleryView else { return }
            galleryView.datas = product.images
        }
    }

    private var pickerViewController: ProductPickerController?

    override var isHideNavigationBar: Bool { return true }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        guard let product = product else { return }
        galleryView.datas = product.images
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postTrackingEventDetail()
        print("進detail page")
    }

    private func setupTableView() {
        tableView.lk_registerCellWithNib(
            identifier: String(describing: ProductDescriptionTableViewCell.self),
            bundle: nil
        )
        tableView.lk_registerCellWithNib(
            identifier: ProductDetailCell.color,
            bundle: nil
        )
        tableView.lk_registerCellWithNib(
            identifier: ProductDetailCell.label,
            bundle: nil
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.picker,
           let pickerVC = segue.destination as? ProductPickerController {
            pickerVC.delegate = self
            pickerVC.product = product
            pickerViewController = pickerVC
        }
    }

    // MARK: - Action
    private func postTrackingEventDetail() {
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
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "view", eventValue: "product_detail", splitTesting: "fresh") { result in
            switch result {
                case .success:
                    print("Tracking event success.")
                case .failure(let error):
                    print("Tracking event error: \(error)")
            }
        }
    }
    
    func postTrackingEventCart() {
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
    
    private func postTrackingEventClick() {
        print("點擊加入購物車")
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
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "click", eventValue: "cart_adding", splitTesting: "fresh") { result in
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
    
    @IBAction func didTouchAddToCarBtn(_ sender: UIButton) {
        postTrackingEventClick()
        if productPickerView.superview == nil {
            showProductPickerView()
        } else {
            guard
                let color = pickerViewController?.selectedColor,
                let size = pickerViewController?.selectedSize,
                let amount = pickerViewController?.selectedAmount,
                let product = product
            else {
                return
            }
            StorageManager.shared.saveOrder(
                color: color, size: size, amount: amount, product: product,
                completion: { result in
                    switch result {
                    case .success:
                        LKProgressHUD.showSuccess()
                        dismissPicker(pickerViewController!)
                    case .failure:
                        LKProgressHUD.showFailure(text: "儲存失敗！")
                    }
                }
            )
        }
    }

    func showProductPickerView() {
        postTrackingEventCart()
        
        let maxY = tableView.frame.maxY
        productPickerView.frame = CGRect(
            x: 0, y: maxY, width: UIScreen.width, height: 0.0
        )
        baseView.insertSubview(productPickerView, belowSubview: addToCarBtn.superview!)
        baseView.insertSubview(blurView, belowSubview: productPickerView)

        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                guard let self = self else { return }
                let height = 451.0 / 586.0 * self.tableView.frame.height
                self.productPickerView.frame = CGRect(
                    x: 0, y: maxY - height, width: UIScreen.width, height: height
                )
                self.isEnableAddToCarBtn(false)
            }
        )
    }

    func isEnableAddToCarBtn(_ flag: Bool) {
        if flag {
            addToCarBtn.isEnabled = true
            addToCarBtn.backgroundColor = .B1
        } else {
            addToCarBtn.isEnabled = false
            addToCarBtn.backgroundColor = .B4
        }
    }
}

// MARK: - UITableViewDataSource
extension ProductDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard product != nil else { return 0 }
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let product = product else { return UITableViewCell() }
        return datas[indexPath.row].cellForIndexPath(indexPath, tableView: tableView, data: product)
    }
}

extension ProductDetailViewController: LKGalleryViewDelegate {

    func sizeForItem(_ galleryView: LKGalleryView) -> CGSize {
        return CGSize(width: Int(UIScreen.width), height: Int(UIScreen.width / 375.0 * 500.0))
    }
}

extension ProductDetailViewController: ProductPickerControllerDelegate {

    func dismissPicker(_ controller: ProductPickerController) {
        let origin = productPickerView.frame
        let nextFrame = CGRect(x: origin.minX, y: origin.maxY, width: origin.width, height: origin.height)

        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.productPickerView.frame = nextFrame
                self?.blurView.removeFromSuperview()
                self?.isEnableAddToCarBtn(true)
            },
            completion: { [weak self] _ in
                self?.productPickerView.removeFromSuperview()
            }
        )
    }

    func valueChange(_ controller: ProductPickerController) {
        guard
            controller.selectedColor != nil,
            controller.selectedSize != nil,
            controller.selectedAmount != nil
        else {
            isEnableAddToCarBtn(false)
            return
        }
        isEnableAddToCarBtn(true)
    }
}

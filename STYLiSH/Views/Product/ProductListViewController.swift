//
//  ProductListViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/19.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

protocol ProductListDataProvider {
    func fetchData(paging: Int, completion: @escaping ProductsResponseWithPaging)
}

class ProductListViewController: STCompondViewController {

    var provider: ProductListDataProvider?
    
    private let trackingProvider = TrackingProvider()
    
    private var cid: String?
    
    private var memberID: String?
    
    private var eventDate: String?
    
    private var eventTimestamp: Int?

    private var paging: Int? = 0

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupTableView()
        setupCollectionView()
    }

    // MARK: - Private method
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.lk_registerCellWithNib(
            identifier: String(describing: ProductTableViewCell.self),
            bundle: nil
        )
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.lk_registerCellWithNib(
            identifier: String(describing: ProductCollectionViewCell.self),
            bundle: nil
        )
        setupCollectionViewLayout()
    }

    private func setupCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(
            width: Int(164.0 / 375.0 * UIScreen.width),
            height: Int(164.0 / 375.0 * UIScreen.width * 308.0 / 164.0)
        )
        flowLayout.sectionInset = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 24.0
        collectionView.collectionViewLayout = flowLayout
    }

    // MARK: - Override super class method
    override func headerLoader() {
        paging = nil
        datas = []
        resetNoMoreData()

        provider?.fetchData(paging: 0, completion: { [weak self] result in
            self?.endHeaderRefreshing()
            switch result {
            case .success(let response):
                self?.datas = [response.data]
                self?.paging = response.paging
            case .failure(let error):
                LKProgressHUD.showFailure(text: error.localizedDescription)
            }
        })
    }

    override func footerLoader() {
        guard let paging = paging else {
            endWithNoMoreData()
            return
        }
        provider?.fetchData(paging: paging, completion: { [weak self] result in
            self?.endFooterRefreshing()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let originalData = self.datas.first else { return }
                let newDatas = response.data
                self.datas = [originalData + newDatas]
                self.paging = response.paging
            case .failure(let error):
                LKProgressHUD.showFailure(text: error.localizedDescription)
            }
        })
    }

    private func showProductDetailViewController(product: Product) {
        let productDetailVC = UIStoryboard.product.instantiateViewController(withIdentifier:
            String(describing: ProductDetailViewController.self)
        )
        guard let detailVC = productDetailVC as? ProductDetailViewController else { return }
        detailVC.product = product
        show(detailVC, sender: nil)
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
        print("點擊女裝/男裝/配件商品資訊")
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
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "click", eventValue: "product_image", splitTesting: "fresh") { result in
            switch result {
                case .success:
                    print("Tracking event success.")
                case .failure(let error):
                    print("Tracking event error: \(error)")
            }
        }
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ProductTableViewCell.self),
            for: indexPath
        )
        guard
            let productCell = cell as? ProductTableViewCell,
            let product = datas[indexPath.section][indexPath.row] as? Product
        else {
            return cell
        }
        productCell.layoutCell(
            image: product.mainImage,
            title: product.title,
            price: product.price
        )
        return productCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postTrackingEventClick()
        tableView.deselectRow(at: indexPath, animated: true)
        guard let product = datas[indexPath.section][indexPath.row] as? Product else { return }
        showProductDetailViewController(product: product)
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductCollectionViewCell.self),
            for: indexPath
        )
        guard
            let productCell = cell as? ProductCollectionViewCell,
            let product = datas[indexPath.section][indexPath.row] as? Product
        else {
            return cell
        }
        productCell.layoutCell(
            image: product.mainImage,
            title: product.title,
            price: product.price
        )
        return productCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        postTrackingEventClick()
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let product = datas[indexPath.section][indexPath.row] as? Product else { return }
        showProductDetailViewController(product: product)
    }
}

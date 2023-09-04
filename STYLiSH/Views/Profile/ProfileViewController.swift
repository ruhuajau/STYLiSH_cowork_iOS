//
//  ProfileViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/14.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    private let trackingProvider = TrackingProvider()
    
    private var cid: String?
    
    private var memberID: String?
    
    private var eventDate: String?
    
    private var eventTimestamp: Int?
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelInfo: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    private let manager = ProfileManager()
    
    private let userProvider = UserProvider()
    
    private var user: User? {
        didSet {
            if let user = user {
                updateUser(user)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        postTrackingEvent()
    }
    
    // MARK: - Action
    private func postTrackingEvent() {
        print("進入會員資訊頁")
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
        
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "view", eventValue: "profile", splitTesting: "fresh") { result in
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
    
    private func fetchData() {
        userProvider.getUserProfile(completion: { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure:
                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
    }
    
    private func updateUser(_ user: User) {
        imageProfile.loadImage(user.picture, placeHolder: .asset(.Icons_36px_Profile_Normal))
        
        labelName.text = user.name
        labelInfo.text = user.getUserInfo()
        labelInfo.isHidden = false
    }
}

extension ProfileViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.groups.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.groups[section].items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProfileCollectionViewCell.self),
            for: indexPath
        )
        guard let profileCell = cell as? ProfileCollectionViewCell else { return cell }
        let item = manager.groups[indexPath.section].items[indexPath.row]
        profileCell.layoutCell(image: item.image, text: item.title)
        return profileCell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: String(describing: ProfileCollectionReusableView.self),
                for: indexPath
            )
            guard let profileView = header as? ProfileCollectionReusableView else { return header }
            let group = manager.groups[indexPath.section]
            profileView.layoutView(title: group.title, actionText: group.action?.title)
            return profileView
        }
        return UICollectionReusableView()
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.width / 5.0, height: 60.0)
        } else if indexPath.section == 1 {
            return CGSize(width: UIScreen.width / 4.0, height: 60.0)
        }
        return CGSize.zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24.0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 24.0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: UIScreen.width, height: 48.0)
    }
}

//
//  CheckoutResultViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/31.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class CheckoutResultViewController: STBaseViewController {

    private let trackingProvider = TrackingProvider()
    
    private var cid: String?
    
    private var memberID: String?
    
    private var eventDate: String?
    
    private var eventTimestamp: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postTrackingEvent()
    }
    
    override func backToRoot(_ sender: Any) {
        backToRoot(completion: {
            //TODO: 更新
//            let appdelegate = UIApplication.shared.delegate as? AppDelegate
//            let root = appdelegate?.window?.rootViewController as? STTabBarViewController
//            root?.selectedIndex = 0
            
        })
    }
    
    private func postTrackingEvent() {
        print("進入結帳成功頁")
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
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "view", eventValue: "checkout_success", splitTesting: "fresh") { result in
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
    
}

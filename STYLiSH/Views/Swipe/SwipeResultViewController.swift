//
//  SwipeResultViewController.swift
//  STYLiSH
//
//  Created by Renee Hsu on 2023/9/2.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
import Foundation

class SwipeResultViewController: UIViewController {
    
    @IBOutlet weak var styleLabel: UILabel!
    
    @IBOutlet weak var styleImageView: UIImageView!
    
    //TODO: 更新Image
    
    private let trackingProvider = TrackingProvider()
    
    private var cid: String?
    
    private var memberID: String?
    
    private var eventDate: String?
    
    private var eventTimestamp: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTrackingEventTinder()
        
        if UserDataManager.shared.style == "A" {
            styleLabel.text = "簡約風"
        } else if UserDataManager.shared.style == "B" {
            styleLabel.text = "運動風"
        } else if UserDataManager.shared.style == "C" {
            styleLabel.text = "休閒風"
        }
    }
    
    private func postTrackingEventTinder() {
        print("進入Tinder結果")
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
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "view", eventValue: "tinder", splitTesting: "fresh") { result in
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
    
    private func postTrackingEventKeepShopping() {
        print("Tinder繼續逛逛")
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
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "click", eventValue: "tinder_keep_shopping", splitTesting: "fresh") { result in
            switch result {
                case .success:
                    print("Tracking event success.")
                case .failure(let error):
                    print("Tracking event error: \(error)")
            }
        }
    }
    
    private func postTrackingEventSignIn() {
        print("Tinder登入")
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
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "click", eventValue: "tinder_signin", splitTesting: "fresh") { result in
            switch result {
                case .success:
                    print("Tracking event success.")
                case .failure(let error):
                    print("Tracking event error: \(error)")
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        postTrackingEventSignIn()
        guard let authVC = UIStoryboard.auth.instantiateInitialViewController() else { return }
        authVC.modalPresentationStyle = .overCurrentContext
        present(authVC, animated: false, completion: nil)
        print("UserData style: \(UserDataManager.shared.style)")
    }
    
    @IBAction func backToHomePageButtonTapped(_ sender: Any) {
        postTrackingEventKeepShopping()
        guard let mainVC = UIStoryboard.main.instantiateInitialViewController() else { return }
        mainVC.modalPresentationStyle = .overCurrentContext
        present(mainVC, animated: false, completion: nil)
        print("UserData style: \(UserDataManager.shared.style)")
    }
    
}

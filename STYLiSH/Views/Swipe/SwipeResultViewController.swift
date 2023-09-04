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
    
    private let trackingProvider = TrackingProvider()
    
    private var cid: String?
    
    private var memberID: String?
    
    private var eventDate: String?
    
    private var eventTimestamp: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureEventDate()
        configureEventTimestamp()
        postTrackingEvent()
    }
    
    private func postTrackingEvent() {
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
        
        trackingProvider.trackEvent(cid: cid!, memberID: memberID, eventDate: eventDate!, eventTimestamp: eventTimestamp!, eventType: "view", eventValue: "tinder", splitTesting: "A") { result in
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
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let authVC = UIStoryboard.auth.instantiateInitialViewController() else { return }
        authVC.modalPresentationStyle = .overCurrentContext
        present(authVC, animated: false, completion: nil)
    
    }
    
    @IBAction func backToHomePageButtonTapped(_ sender: Any) {
        guard let mainVC = UIStoryboard.main.instantiateInitialViewController() else { return }
        mainVC.modalPresentationStyle = .overCurrentContext
        present(mainVC, animated: false, completion: nil)
    }
    
}

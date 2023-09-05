//
//  TrackingProvider.swift
//  STYLiSH
//
//  Created by Renee Hsu on 2023/9/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

class TrackingProvider {

    func trackEvent(
        cid: String,
        memberID: String?,
        eventDate: String,
        eventTimestamp: Int,
        eventType: String,
        eventValue: String,
        splitTesting: String,
        completion: @escaping (Result<Void>) -> Void
    ) {
        let request = STTrackingRequest.trackEvent(
            cid: cid,
            memberID: memberID,
            eventDate: eventDate,
            eventTimestamp: eventTimestamp,
            eventType: eventType,
            eventValue: eventValue,
            splitTesting: splitTesting
        )
        
        HTTPClient.shared.request(request) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion(Result.success(()))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
    }
}

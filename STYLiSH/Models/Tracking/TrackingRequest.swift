//
//  TrackingRequest.swift
//  STYLiSH
//
//  Created by Renee Hsu on 2023/9/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

enum STTrackingRequest: STRequest {
    case trackEvent(
        cid: String,
        memberID: String?,
        eventDate: String,
        eventTimestamp: Int,
        eventType: String,
        eventValue: String
    )

    var headers: [String: String] {
        return [
            STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
        ]
    }

    var body: Data? {
        switch self {
            case .trackEvent(let cid, let memberID, let eventDate, let eventTimestamp, let eventType, let eventValue):
            let dict: [String: Any] = [
                "cid": cid,
                "member_id": memberID ?? "None",
                "device_os": "iOS",
                "event_date": eventDate,
                "event_timestamp": eventTimestamp,
                "event_type": eventType,
                "event_value": eventValue
            ]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }
    }

    var method: String {
        return STHTTPMethod.POST.rawValue
    }

    var endPoint: String {
        return "/tracking"
    }
}

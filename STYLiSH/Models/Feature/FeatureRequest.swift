//
//  FeatureRequest.swift
//  STYLiSH
//
//  Created by Renee Hsu on 2023/9/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

enum STFeatureRequest: STRequest {
    case colorPicker(
        cid: String,
        memberID: String?,
        eventDate: String,
        eventTimestamp: Int,
        hairColor: String,
        skinColor: String
    )

    var headers: [String: String] {
        return [
            STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
        ]
    }

    var body: Data? {
        switch self {
        case .colorPicker(let cid, let memberID, let eventDate, let eventTimestamp, let hairColor, let skinColor):
            let dict: [String: Any] = [
                "cid": cid,
                "member_id": memberID ?? "None",
                "device_os": "iOS",
                "event_date": eventDate,
                "event_timestamp": eventTimestamp,
                "hair": hairColor,
                "skin": skinColor
            ]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }
    }

    var method: String {
        return STHTTPMethod.POST.rawValue
    }

    var endPoint: String {
        return "/feature/color_picker"
    }
}

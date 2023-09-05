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
        deviceOS: String,
        eventTimestamp: Int,
        hairColor: String,
        skinColor: String,
        colors: [String]
    )
    
    case productTinder

    var headers: [String: String] {
        switch self {
            case .colorPicker:
                return [
                    STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
                ]
            case .productTinder:
                return [:]
        }
    }

    var body: Data? {
        switch self {
        case .colorPicker(let cid, let memberID, let eventDate, let deviceOS, let eventTimestamp, let hairColor, let skinColor, let colors):
            let dict: [String: Any] = [
                "cid": cid,
                "member_id": memberID ?? "None",
                "device_os": "iOS",
                "event_date": eventDate,
                "event_timestamp": eventTimestamp,
                "hair": hairColor,
                "skin": skinColor,
                "colors": colors
            ]
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            case .productTinder:
                return nil
        }
    }

    var method: String {
        switch self {
            case .colorPicker:
                return STHTTPMethod.POST.rawValue
            case .productTinder:
                return STHTTPMethod.GET.rawValue
        }
    }

    var endPoint: String {
        switch self {
            case .colorPicker:
                return "/color_picker"
            case .productTinder:
                return "/product_tinder"
        }
    }
}

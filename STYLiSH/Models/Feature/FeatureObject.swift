//
//  FeatureObject.swift
//  STYLiSH
//
//  Created by Renee Hsu on 2023/9/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

struct ColorData: Codable {
    let data: ColorResponse
}

// MARK: - DataClass
struct ColorResponse: Codable {
    let cid, memberID, recommendColor: String

    enum CodingKeys: String, CodingKey {
        case cid
        case memberID = "member_id"
        case recommendColor = "recommend_color"
    }
}

struct TinderObject: Codable {
    let data: Datum
}

// MARK: - Datum
struct Datum: Codable {
    let images: [String]?
    let style: [String]?
}

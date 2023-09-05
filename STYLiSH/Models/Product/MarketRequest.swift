//
//  STRequest.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

enum STMarketRequest: STRequest {
    case styleA
    case styleB
    case styleC
    case women(paging: Int)
    case men(paging: Int)
    case accessories(paging: Int)
    
    var headers: [String: String] {
        switch self {
            case .styleA, .styleB, .styleC, .women, .men, .accessories: return [:]
        }
    }
    
    var body: Data? {
        switch self {
            case .styleA, .styleB, .styleC, .women, .men, .accessories: return nil
        }
    }
    
    var method: String {
        switch self {
            case .styleA, .styleB, .styleC, .women, .men, .accessories: return STHTTPMethod.GET.rawValue
        }
    }
    
    var endPoint: String {
        switch self {
            case .styleA: return "/products/style?style=A"
            case .styleB: return "/products/style?style=B"
            case .styleC: return "/products/style?style=C"
            case .women(let paging): return "/products/women?paging=\(paging)"
            case .men(let paging): return "/products/men?paging=\(paging)"
            case .accessories(let paging): return "/products/accessories?paging=\(paging)"
        }
    }
}

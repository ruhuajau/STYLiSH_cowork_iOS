//
//  UserRequest.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

enum STUserRequest: STRequest {
    case signin(email: String, password: String)
    case signup(email: String, password: String)
    case checkout(token: String, body: Data?)
    case checkoutWithCash(token: String, body: Data?)
    case profile(token: String)
    
    var headers: [String: String] {
        switch self {
            case .signin, .signup:
                return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]
            case .checkout(let token, _), .checkoutWithCash(let token, _):
                return [
                    STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                    STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
                ]
            case .profile(let token):
                return [
                    STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                    STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
                ]
        }
    }
    
    var body: Data? {
        switch self {
            case .signin(let email, let password):
                let dict = [
                    "provider": "native",
                    "email": email,
                    "password": password
                ]
                return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            case .signup(let email, let password):
                let dict = [
                    "email": email,
                    "password": password
                ]
                return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            case .checkout(_, let body), .checkoutWithCash(_, let body):
                return body
            case .profile: return nil
        }
    }
    
    var method: String {
        switch self {
            case .signin, .signup, .checkout, .checkoutWithCash: return STHTTPMethod.POST.rawValue
            case .profile: return STHTTPMethod.GET.rawValue
        }
    }
    
    var endPoint: String {
        switch self {
            case .signin: return "/signin"
            case .signup: return "/signup"
            case .checkout, .checkoutWithCash: return "/order/checkout"
            case .profile: return "/profile"
        }
    }
}

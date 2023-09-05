//
//  UserDataManager.swift
//  STYLiSH
//
//  Created by Renee Hsu on 2023/9/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

class UserDataManager {
    
    static let shared = UserDataManager()
    
    private init() {}
    
    var cid: String?
    
    var memberID: String?
}

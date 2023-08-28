//
//  UserProfileList.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Foundation

struct UserProfileList {
    var list: [UserProfile]
    var page: Int
    
    init(
        list: [UserProfile],
        page: Int
    ) {
        self.list = list
        self.page = page
    }
}

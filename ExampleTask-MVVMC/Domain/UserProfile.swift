//
//  UserProfile.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Foundation

struct UserProfile: Hashable {
    let id: String
    let gender: UserGender
    let name: String
    let email: String
    let age: String
    let phone: String
    let cell: String
    let picture: String
    let loaction: String
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id
    }
}

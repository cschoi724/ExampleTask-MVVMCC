//
//  UserRequestDTO.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Foundation

struct UserRequestDTO: Codable {
    var gender: String
    var page: Int
    var results: Int
}

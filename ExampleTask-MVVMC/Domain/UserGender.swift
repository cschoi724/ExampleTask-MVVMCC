//
//  UserGender.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Foundation

enum UserGender: RawRepresentable {
    typealias RawValue = String
    case male, female
    
    init(rawValue: String) {
        switch rawValue {
        case "male": self = .male
        case "female": self = .female
        default: self = .male
        }
    }
    
    var rawValue: String {
        switch self {
        case .male: return "male"
        case .female: return "female"
        }
    }
}

//
//  UserResponseDTO.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Foundation

struct UserResponseDTO: Codable {
    let results: [UserDTO]
    let info: Info!
    
    enum CodingKeys: CodingKey {
        case results
        case info
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = (try? container.decode([UserDTO].self, forKey: .results)) ?? []
        self.info = (try? container.decode(Info.self, forKey: .info)) ?? nil
    }
}

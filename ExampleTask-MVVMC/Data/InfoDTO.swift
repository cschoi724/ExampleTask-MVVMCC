//
//  InfoDTO.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Foundation

struct Info: Codable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.seed = (try? container.decode(String.self, forKey: .seed)) ?? ""
        self.results = (try? container.decode(Int.self, forKey: .results)) ?? 0
        self.page = (try? container.decode(Int.self, forKey: .page)) ?? 0
        self.version = (try? container.decode(String.self, forKey: .version)) ?? ""
    }
}

//
//  APIEndpoints.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Foundation

class APIEndpoints {
    
    static func getUsers(_ requestDTO: UserRequestDTO) -> Endpoint<UserResponseDTO> {
        return Endpoint(
            path: "",
            method: .get,
            queryParametersEncodable: requestDTO
        )
    }
    
}

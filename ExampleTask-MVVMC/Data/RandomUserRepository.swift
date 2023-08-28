//
//  RandomUserRepository.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/10.
//

import Foundation

protocol RandomUserRepository {
    func fetchRandomUserList(
        _ requestDTO: UserRequestDTO,
        completionHandler: @escaping (Result<UserResponseDTO,Error>) -> Void
    )
}

class ImpRandomUserRepository: RandomUserRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchRandomUserList(
        _ requestDTO: UserRequestDTO,
        completionHandler: @escaping (Result<UserResponseDTO, Error>) -> Void
    ) {
        let endpoint = APIEndpoints.getUsers(requestDTO)
        networkService.request(
            with: endpoint,
            completion: { result in
                switch result {
                case .success(let dto):
                    completionHandler(.success(dto))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        )
    }
}

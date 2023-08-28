//
//  NetworkService.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Foundation

protocol NetworkService {
    typealias ResultHandler<T> = (Result<T, NetworkError>) -> Void
    
    @discardableResult
    func request<T: Codable, E: Requestable>(with endpoint: E, completion: @escaping ResultHandler<T>) -> NetworkCancellable? where E.Response == T
}

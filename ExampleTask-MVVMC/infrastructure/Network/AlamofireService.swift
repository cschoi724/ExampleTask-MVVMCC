//
//  AlamofireService.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Alamofire
import Foundation

class AlamofireService: NetworkService {
    private var config: NetworkConfigurable
    private let logger: NetworkLogger
    
    public init(
        config: NetworkConfigurable,
        logger: NetworkLogger = DefaultNetworkLogger()
    ) {
        self.logger = logger
        self.config = config
    }
    
    func request<T: Codable, E: Requestable&Responsable>(
        with endpoint: E,
        completion: @escaping ResultHandler<T>
    ) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
    
    private func request<T: Codable>(
        request: URLRequest,
        completion: @escaping ResultHandler<T>
    ) -> NetworkCancellable {
        return AF.request(request)
            .responseDecodable(of: T.self) { response in
                self.logger.log(
                    urlRequest: response.request,
                    response: response.result
                )
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    let networkError = self.errorResolve(with: error)
                    completion(.failure(networkError))
                }
            }
    }
    
    
    private func errorResolve(with error: AFError) -> NetworkError {
        switch error {
        case .explicitlyCancelled:
            return .cancelled
        case .invalidURL:
            return .urlGeneration
        case .sessionInvalidated,
                .sessionTaskFailed:
            return .notConnected
        default:
            return .generic(error)
        }
    }
    
}

extension DataRequest: NetworkCancellable {
    func cancel() {
        super.cancel()
    }
}

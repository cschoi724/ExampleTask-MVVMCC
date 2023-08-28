//
//  NetworkError.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Foundation
// MARK: NetworkError
enum NetworkError: Error {
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
    case encodingFailed(reason: EncodingFailureReason)
    
    public enum EncodingFailureReason {
        case missingURL
        case jsonEncodingFailed(_ error: Error)
        case urlEncodingFailed(_ error: Error)
    }
}

// MARK: RequestGenerationError
enum RequestGenerationError: Error {
    case components
    case url
}

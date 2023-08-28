//
//  NetworkConfigurable.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Foundation
protocol NetworkConfigurable {
    var baseURL: URL { get set}
    var headers: [String: String] { get set}
    var queryParameters: [String: String] { get set}
    var bodyParameters: [String: Any] { get set}
}

struct APINetworkConfig: NetworkConfigurable {
    public var baseURL: URL
    public var headers: [String: String]
    public var queryParameters: [String: String]
    public var bodyParameters: [String: Any]
    
    public init(
        baseURL: URL,
        headers: [String: String] = [:],
        queryParameters: [String: String] = [:],
        bodyParameters: [String: Any] = [:]
    ) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
    }
}

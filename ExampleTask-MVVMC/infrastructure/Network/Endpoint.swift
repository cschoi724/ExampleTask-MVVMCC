//
//  Endpoint.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Foundation
// MARK: - Endpoint
class Endpoint<R>: Requestable {
    typealias Response = R
    
    let path: String
    let isFullPath: Bool
    let method: HTTPMethodType
    let headerParameters: [String: String]
    let queryParametersEncodable: Encodable?
    let queryParameters: [String: Any]
    let bodyParametersEncodable: Encodable?
    let bodyParameters: [String: Any]
    
    init(
        path: String,
        isFullPath: Bool = false,
        method: HTTPMethodType,
        headerParameters: [String: String] = [:],
        queryParametersEncodable: Encodable? = nil,
        queryParameters: [String: Any] = [:],
        bodyParametersEncodable: Encodable? = nil,
        bodyParameters: [String: Any] = [:]
    ) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
    }
}

// MARK: - Responsable
protocol Responsable {
    associatedtype Response
}

// MARK: - Requestable
protocol Requestable: Responsable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

extension Requestable {
    func url(with config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL.absoluteString.last != "/" ? config.baseURL.absoluteString + "/" : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw RequestGenerationError.components
        }
        
        var urlQueryItems: [URLQueryItem] = []

        let queryParameters = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ?
        urlQueryItems : nil
        
        guard let url = urlComponents.url else {
            throw RequestGenerationError.url
        }
        
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers
        headerParameters.forEach { allHeaders.updateValue($1, forKey: $0) }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        urlRequest.timeoutInterval = 10
        
        var bodyParameters = config.bodyParameters
        if let body = try bodyParametersEncodable?.toDictionary() {
            bodyParameters.merge(body) { _, new in new }
        }
        bodyParameters.merge(self.bodyParameters) { _, new in new }
        return urlRequest
    }

}

// MARK: HTTPMethod
struct HTTPMethodType: RawRepresentable, Equatable, Hashable {
    static let connect = HTTPMethodType(rawValue: "CONNECT")
    static let delete = HTTPMethodType(rawValue: "DELETE")
    static let get = HTTPMethodType(rawValue: "GET")
    static let head = HTTPMethodType(rawValue: "HEAD")
    static let options = HTTPMethodType(rawValue: "OPTIONS")
    static let patch = HTTPMethodType(rawValue: "PATCH")
    static let post = HTTPMethodType(rawValue: "POST")
    static let put = HTTPMethodType(rawValue: "PUT")
    static let query = HTTPMethodType(rawValue: "QUERY")
    static let trace = HTTPMethodType(rawValue: "TRACE")
    let rawValue: String
}

// MARK: Encodable+
extension Encodable {
    fileprivate func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
}

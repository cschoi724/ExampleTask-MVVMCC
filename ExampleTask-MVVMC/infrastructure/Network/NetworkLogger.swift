//
//  NetworkLogger.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/11.
//

import Alamofire
import Foundation

public protocol NetworkLogger {
    func log(urlRequest: URLRequest)
    func log<T: Codable, E: Error>(urlRequest: URLRequest?, response: Result<T, E>)
}

public final class DefaultNetworkLogger: NetworkLogger {
    public init() { }
    
    private func println(_ object: Any) {
        if let mode = getenv("ShowLog"),
           (strcmp(mode, "true") == 0) {
            if let mode = getenv("OS_ACTIVITY_MODE"),
               (strcmp(mode, "disable") == 0) {
                print(object)
            } else {
                NSLog("\(object)")
            }
        } else {
            #if DEBUG
            if let mode = getenv("OS_ACTIVITY_MODE"),
               (strcmp(mode, "disable") == 0) {
                print(object)
            } else {
                NSLog("\(object)")
            }
            #endif
        }
    }
    
    public func log(urlRequest: URLRequest) {
        let header = urlRequest.headers
            .filter { $0.name.contains("Authorization") == false }
            .filter { $0.name.contains("RefreshToken") == false }
        let body = toPrettyPrintedString(urlRequest.httpBody) ?? ""
        let Authorization = urlRequest.headers["Authorization"] ?? "??"
        let RefreshToken = urlRequest.headers["RefreshToken"] ?? "??"
        
        println("⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽")
        println("|Network Reqeust/Response LOG 🛰 ↓ ↓ ↓ ↓ ↓ ↓")
        println("|" + urlRequest.description)
        println(
            "|URL: " + (urlRequest.url?.absoluteString ?? "??") + "\n"
            + "|Method: " + (urlRequest.httpMethod ?? "??") + "\n"
            + "|Headers: " + "\(header)" + "\n"
            + "|Authorization: " + Authorization + "\n"
            + "|RefreshToken: " + RefreshToken + "\n"
            + "|BodyParameter: " + body
        )
    }
    
    public func log<T: Codable, E: Error>(urlRequest: URLRequest?, response: Result<T, E>) {
        if let reuqest = urlRequest {
            log(urlRequest: reuqest)
        } else {
            println("|URLReuqest Validation Failed ‼️")
        }
        
        switch response {
        case .success(let data):
            println("|Result ⇢ success")
            println(self.toString(data))
        case .failure(let error):
            println("|Result ⇢ failure")
            if let afError = error as? AFError {
                println("\(afError)")
            } else {
                println("\(error)")
            }
        }
        println("|⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽\n")
    }
    
    public func log(error: Error) {
        println("🛰 Network Error")
        println("\(error)")
    }
    
    func toPrettyPrintedString(_ data: Data?) -> String? {
        guard let data = data,
              let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
    
    func toString<T: Encodable>(_ data: T) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(data)
        if let jsonData = data, let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            return "Parse Error"
        }
    }
}

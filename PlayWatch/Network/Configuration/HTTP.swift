//
//  HTTP.swift
//  PlayWatch
//
//  Created by David on 7/4/24.
//

import Foundation

struct HTTP {
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    struct Header {
        enum Field: String {
            case authorization = "Authorization",
                 accept = "Accept",
                 contentType = "Content-Type"
        }
        
        enum Value: CustomStringConvertible {
            case applicationJson,
                 bearer(API.Key)
            
            var description: String {
                switch self {
                case .applicationJson:
                    return "application/json"
                case .bearer(let key):
                    return "Bearer \(key)"
                }
            }
        }
    }
    
    static func request(
        url: URL,
        method: Method = .get,
        headers:  [Header.Field: Header.Value],
        body: Data? = nil,
        timeout: TimeInterval = Configuration.defaultTimeout
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeout
        request.allHTTPHeaderFields = headers.toHTTPHeaderFields
        request.httpBody = body
        return request
    }
}

// MARK: - Configuration
extension HTTP {
    struct Configuration {
        static let defaultTimeout: TimeInterval = 25
    }
}


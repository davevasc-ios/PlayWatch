//
//  HTTP.swift
//  PlayWatch
//
//  Created by David on 7/4/24.
//

import Foundation

struct HTTP {
    static let timeoutInterval: Double = 25
    static let successCode = 200
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
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
    
    static func request(url: URL, method: Method, fields: [String : String], body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = self.timeoutInterval
        request.allHTTPHeaderFields = fields
        request.httpBody = body
        return request
    }
}

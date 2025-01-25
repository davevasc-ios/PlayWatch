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
    
    // TODO: - DUDA: cambiar a tipos custom? en toda la app voy a usar los custom siempre, no?
    static func request(
        url: URL,
        method: String,
        headers: [String : String],
        body: Data? = nil,
        timeout: TimeInterval = Configuration.defaultTimeout
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = timeout
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
    
    static func url(
        baseURL: String,
        path: String? = nil,
        queryItems: [URLQueryItem]? = nil,
        apiKey: String? = nil
    ) throws -> URL {
        guard var components = URLComponents(string: baseURL) else {
            throw API.Error.invalidURL
        }
        if let path, !path.isEmpty {
            components.path = components.path.appending(path.starts(with: "/") ? path : "/\(path)")
        }
        var finalQueryItems = queryItems.orEmpty
        if let apiKey, !apiKey.isEmpty {
            finalQueryItems.append(URLQueryItem(name: "key", value: apiKey))
        }
        components.queryItems = finalQueryItems
        guard let url = components.url else {
            throw API.Error.invalidURL
        }
        return url
    }
}

// MARK: - Configuration
extension HTTP {
    struct Configuration {
        static let defaultTimeout: TimeInterval = 25
    }
}

// MARK: - QueryItem Optional
extension Optional where Wrapped == [URLQueryItem] {
    var orEmpty: [URLQueryItem] { self ?? [] }
}

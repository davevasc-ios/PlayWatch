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
}

// MARK: - HTTP Methods
extension HTTP {
    
    static func url(
        baseURL: String,
        path: String? = nil,
        queryItems: [URLQueryItem]? = nil,
        apiKey: API.Key? = nil
    ) throws -> URL {
        
        guard var components = URLComponents(string: baseURL) else {
            throw API.Error.invalidURL
        }
        if let path, !path.isEmpty {
            components.path = components.path.appending(path.starts(with: "/") ? path : "/\(path)")
        }
        var finalQueryItems = queryItems.orEmpty
        if let apiKey = apiKey?.description, !apiKey.isEmpty {
            finalQueryItems.append(URLQueryItem(name: "key", value: apiKey))
        }
        components.queryItems = finalQueryItems
        guard let url = components.url else {
            throw API.Error.invalidURL
        }
        return url
    }
    
    static func request(
        url: URL,
        method: Method,
        headers: [Header.Field : Header.Value],
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

// MARK: - QueryItem Optional Extension
extension Optional where Wrapped == [URLQueryItem] {
    
    var orEmpty: [URLQueryItem] { self ?? [] }
}

// MARK: - QueryItem Extension
extension URLQueryItem {
    
    init(_ param: MovieDBSorting.QueryParams, _ value: String?) {
        self.init(name: param.rawValue, value: value)
    }
    
    init(_ param: MovieDBSorting.QueryParams, _ sort: MovieDBSorting.QueryDirection, _ value: String?) {
        self.init(name: param.rawValue + sort.rawValue, value: value)
    }
    
    init(_ param: MovieDBSorting.QueryParams, _ value: MovieDBSorting.SortBy, _ sort: MovieDBSorting.SortDirection) {
        self.init(name: param.rawValue, value: value.rawValue + sort.rawValue)
    }
    
    init(_ param: MovieDBSorting.QueryParams, _ value: MovieDBSorting.MonetizationType) {
        self.init(name: param.rawValue, value: value.rawValue)
    }
}

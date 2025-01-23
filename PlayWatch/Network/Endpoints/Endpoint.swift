//
//  Endpoint.swift
//  PlayWatch
//
//  Created by David on 22/1/25.
//

import Foundation

protocol EndpointProtocol: Sendable {
    var urlConfig: URLConfigProtocol { get }
    var requestConfig: URLRequestConfigProtocol { get }
}

extension EndpointProtocol {
    func createRequest(config: MediaRequestConfig) throws -> URLRequest {
        let url = try self.urlConfig.createURL(config: config)
        return try self.requestConfig.createRequest(url: url)
    }
}

struct MovieDBEndpoint: EndpointProtocol {
    let urlConfig: URLConfigProtocol
    let requestConfig: URLRequestConfigProtocol
    
    init(urlConfig: URLConfigProtocol = MovieDBURLConfig(),
         requestConfig: URLRequestConfigProtocol = MovieDBURLRequestConfig()) {
        self.urlConfig = urlConfig
        self.requestConfig = requestConfig
    }
}

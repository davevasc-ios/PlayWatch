//
//  URLRequestConfig.swift
//  PlayWatch
//
//  Created by David on 22/1/25.
//

import Foundation

protocol URLRequestConfigProtocol: Sendable {
    var method: HTTP.Method { get }
    var headers: [HTTP.Header.Field: HTTP.Header.Value] { get }
    var body: Data? { get }
    var timeout: TimeInterval { get }
}

extension URLRequestConfigProtocol {
    func createRequest(url: URL) throws -> URLRequest {
        HTTP.request(
            url: url,
            method: self.method,
            headers: self.headers,
            body: self.body,
            timeout: self.timeout
        )
    }
}

struct MovieDBURLRequestConfig: URLRequestConfigProtocol {
    var method: HTTP.Method = .get
    var headers: [HTTP.Header.Field : HTTP.Header.Value] = Constants.headers
    var body: Data? = nil
    var timeout: TimeInterval = HTTP.Configuration.defaultTimeout
}

// TODO: - OpenAI y Gemini URLRequestConfig

//struct OpenAIURLRequestConfig: URLConfigProtocol {
//
//}

//struct GeminiURLRequestConfig: URLConfigProtocol {
//
//}

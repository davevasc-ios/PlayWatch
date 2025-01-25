//
//  Endpoint.swift
//  PlayWatch
//
//  Created by David on 22/1/25.
//

import Foundation

protocol EndpointProtocol: Sendable {
    var baseURL: String { get }
    var method: HTTP.Method { get }
    var headers: [HTTP.Header.Field: HTTP.Header.Value] { get }
}

extension EndpointProtocol { // where Self == MovieDBEndpoint {
    
    func createRequest(config: MediaRequestConfig) throws -> URLRequest {
        let url = try HTTP.url(
            baseURL: self.baseURL,
            path: Constants.paths[config.mediaType],
            queryItems: config.mediaType.queryParameters(for: config.locale, searchText: config.searchQuery)
        )
        return HTTP.request(
            url: url,
            method: self.method.rawValue,
            headers: self.headers.toHTTPHeaderFields
        )
    }
    
    func createRequest(config: GameRequestConfig) throws -> URLRequest {
        let aiEndpoint: AIEndpointProtocol = switch config.aiServer {
        case .openAI: OpenAIEndpoint()
        case .gemini: GeminiEndpoint()
        }
        return try aiEndpoint.createRequest(config: config)
    }
}

struct MovieDBEndpoint: EndpointProtocol {
    static let imageURL = "https://image.tmdb.org/t/p/"
    let baseURL = "https://api.themoviedb.org/3/"
    let method: HTTP.Method = .get
    let headers: [HTTP.Header.Field: HTTP.Header.Value] = [
        .accept: .applicationJson,
        .authorization: .bearer(.movieDB)
    ]
}

// TODO: - DUDA: esto no se usa... repensarlo...
struct MultiAIEndpoint: EndpointProtocol {
    var headers: [HTTP.Header.Field : HTTP.Header.Value] = [:]
    let baseURL = ""
    let method: HTTP.Method = .post
}

protocol AIEndpointProtocol: Sendable {
    var baseURL: String { get }
    var apiKey: String? { get }
    var method: HTTP.Method { get }
    var headers: [HTTP.Header.Field: HTTP.Header.Value] { get }
    func body(movies: String, language: String) throws -> Data?
 }

extension AIEndpointProtocol {
    func createRequest(config: GameRequestConfig) throws -> URLRequest {
        HTTP.request(
            url: try HTTP.url(baseURL: self.baseURL, apiKey: self.apiKey),
            method: self.method.rawValue,
            headers: self.headers.toHTTPHeaderFields,
            body: try self.body(movies: config.movies, language: config.language)
        )
    }
}

struct OpenAIEndpoint: AIEndpointProtocol {
    let baseURL: String = "https://api.openai.com/v1/chat/completions"
    let apiKey: String? = nil
    let method: HTTP.Method = .post
    let headers: [HTTP.Header.Field : HTTP.Header.Value] = [
        .contentType: .applicationJson,
        .authorization: .bearer(.openAI)
    ]
    func body(movies: String, language: String) throws -> Data? {
        try OpenAIBody.encode(movies: movies, language: language)
    }
}

struct GeminiEndpoint: AIEndpointProtocol {
    let baseURL: String = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
    let apiKey: String? = API.Key.gemini.description
    let method: HTTP.Method = .post
    let headers: [HTTP.Header.Field : HTTP.Header.Value] = [
        .contentType: .applicationJson
    ]
    func body(movies: String, language: String) throws -> Data? {
        try GeminiBody.encode(movies: movies, language: language)
    }
}

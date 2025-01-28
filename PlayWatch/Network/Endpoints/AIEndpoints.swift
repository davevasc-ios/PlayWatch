//
//  AIEndpoints.swift
//  PlayWatch
//
//  Created by David on 27/1/25.
//

import Foundation

protocol AIEndpointFactoryProtocol {
    func resolveEndpoint(for aiServer: Constants.AIServer) -> AIEndpointProtocol
}

struct AIEndpointFactory: AIEndpointFactoryProtocol {
    func resolveEndpoint(for aiServer: Constants.AIServer = .openAI) -> AIEndpointProtocol {
        switch aiServer {
        case .openAI: OpenAIEndpoint()
        case .gemini: GeminiEndpoint()
        }
    }
}

protocol AIEndpointProtocol: BaseEndpointProtocol {
    var apiKey: String? { get }
    func body(movies: String, language: String) throws -> Data?
}

extension AIEndpointProtocol {
    func createRequest(movies: String, language: String) throws -> URLRequest {
        HTTP.request(
            url: try HTTP.url(baseURL: self.baseURL, apiKey: self.apiKey),
            method: self.method,
            headers: self.headers,
            body: try self.body(movies: movies, language: language)
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

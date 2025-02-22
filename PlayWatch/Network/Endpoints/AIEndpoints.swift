//
//  AIEndpoints.swift
//  PlayWatch
//
//  Created by David on 27/1/25.
//

import Foundation

protocol AIEndpointFactoryProtocol {
    
    func resolveEndpoint(for aiServer: AIServer) -> AIEndpointProtocol
}

struct AIEndpointFactory: AIEndpointFactoryProtocol {
    
    func resolveEndpoint(for aiServer: AIServer = .openAI) -> AIEndpointProtocol {
        switch aiServer {
        case .openAI: OpenAIEndpoint(model: .gpt3,
                                     systemMode: .json,
                                     output: .text)
        case .gemini: GeminiEndpoint(model: .flash1,
                                     output: .json)
        case .deepSeek: DeepSeekEndpoint(model: .chat,
                                       systemMode: .json,
                                       output: .json)
        }
    }
}

protocol AIEndpointProtocol: BaseEndpointProtocol {
    
    func body(prompt: PromptType) throws -> Data?
}

extension AIEndpointProtocol {
    
    var method: HTTP.Method { .post }
    
    func createRequest(prompt: PromptType) throws -> URLRequest {
        HTTP.request(
            url: try HTTP.url(baseURL: self.baseURL, apiKey: self.apiKey),
            method: self.method,
            headers: self.headers,
            body: try self.body(prompt: prompt),
            timeout: self.timeout
        )
    }
}

struct GeminiEndpoint: AIEndpointProtocol {
 
    let model: GeminiModel
    let output: GeminiOutput
    
    var baseURL: String { "https://generativelanguage.googleapis.com/v1beta/models/\(self.model.rawValue):generateContent" }
    let apiKey: API.Key = .gemini
    let headers: [HTTP.Header.Field : HTTP.Header.Value] = [
        .contentType: .applicationJson
    ]
    let timeout: TimeInterval = 30
    
    func body(prompt: PromptType) throws -> Data? {
        try GeminiBody.encode(output: self.output, prompt: prompt)
    }
}

protocol OpenAICompatibleEndpointProtocol: AIEndpointProtocol {
    
    associatedtype ModelType: OpenAIModelCompatible
    var model: ModelType { get }
    var systemMode: OpenAISystemMode { get }
    var output: OpenAIOutput { get }
}

extension OpenAICompatibleEndpointProtocol {
    
    var headers: [HTTP.Header.Field : HTTP.Header.Value] {
        [.contentType: .applicationJson,
         .authorization: .bearer(self.apiKey)]
    }
    
    func body(prompt: PromptType) throws -> Data? {
        try OpenAIBody.encode(
            modelCompatible: model,
            systemMode: systemMode,
            output: output,
            prompt: prompt
        )
    }
}

struct OpenAIEndpoint: OpenAICompatibleEndpointProtocol {
    
    let model: OpenAIModel
    let systemMode: OpenAISystemMode
    let output: OpenAIOutput
    
    let baseURL = "https://api.openai.com/v1/chat/completions"
    let apiKey: API.Key = .openAI
    let timeout: TimeInterval = 35
}

struct DeepSeekEndpoint: OpenAICompatibleEndpointProtocol {
    
    let model: DeepSeekModel
    let systemMode: OpenAISystemMode
    let output: OpenAIOutput
    
    let baseURL = "https://api.deepseek.com/v1/chat/completions"
    let apiKey: API.Key = .deepSeek
    let timeout: TimeInterval = 55
}

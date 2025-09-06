//
//  AIEndpoints.swift
//  PlayWatch
//
//  Created by David on 27/1/25.
//

import Foundation

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

protocol GeminiEndpointProtocol: AIEndpointProtocol {
    var model: GeminiModel { get }
    var output: GeminiOutput { get }
}

extension GeminiEndpointProtocol {
    var baseURL: String { "https://generativelanguage.googleapis.com/v1beta/models/\(self.model.rawValue):generateContent" }
    var apiKey: API.Key { .gemini }
    var headers: [HTTP.Header.Field : HTTP.Header.Value] { [
        .contentType: .applicationJson
    ] }
    var timeout: TimeInterval { 30 }
    
    func body(prompt: PromptType) throws -> Data? {
        try GeminiBody.encode(
            output: self.output,
            prompt: prompt
        )
    }
}

struct GeminiGameEndpoint: GeminiEndpointProtocol {
    let model: GeminiModel = .flash1
    let output: GeminiOutput = .json
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



protocol OpenAIEndpointProtocol: OpenAICompatibleEndpointProtocol { }

extension OpenAIEndpointProtocol {
    var baseURL: String { "https://api.openai.com/v1/chat/completions" }
    var apiKey: API.Key { .openAI }
    var timeout: TimeInterval { 35 }
}

struct OpenAIGameEndpoint: OpenAIEndpointProtocol {
    let model: OpenAIModel = .gpt3
    let systemMode: OpenAISystemMode = .json
    let output: OpenAIOutput = .text
}





protocol DeepSeekEndpointProtocol: OpenAICompatibleEndpointProtocol { }

extension DeepSeekEndpointProtocol {
    var baseURL: String {  "https://api.deepseek.com/v1/chat/completions" }
    var apiKey: API.Key { .deepSeek }
    var timeout: TimeInterval { 55 }
}

struct DeepSeekGameEndpoint: DeepSeekEndpointProtocol {
    let model: DeepSeekModel = .chat
    let systemMode: OpenAISystemMode = .json
    let output: OpenAIOutput = .json
}

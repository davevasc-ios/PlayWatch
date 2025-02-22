//
//  AIResponseDecoder.swift
//  PlayWatch
//
//  Created by David on 1/2/25.
//

import Foundation

protocol AIResponseDecodable {
    func decode(from data: Data) throws -> String
}

struct OpenAIResponseCompatibleDecoder: AIResponseDecodable {
    func decode(from data: Data) throws -> String {
        try OpenAIResponse.decode(from: data).aiResponseText
    }
}

struct GeminiResponseDecoder: AIResponseDecodable {
    func decode(from data: Data) throws -> String {
        try GeminiResponse.decode(from: data).aiResponseText
    }
}

struct AIResponseDecoderFactory {
    static func decoder(for server: AIServer) -> AIResponseDecodable {
        switch server {
        case .openAI, .deepSeek: OpenAIResponseCompatibleDecoder()
        case .gemini: GeminiResponseDecoder()
        }
    }
}

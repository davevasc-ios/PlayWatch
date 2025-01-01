//
//  OpenAIResponse.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

import Foundation

struct OpenAIResponse: Codable {
    let choices: [Choice]?
}

struct Choice: Codable {
    let message: Message?
}

struct Message: Codable {
    let content: String?
}

// MARK: - Decoding
extension OpenAIResponse {
    static func decode(from data: Data, using decoder: DataDecoder = JSONDecoder()) throws -> Self {
        do {
            return try decoder.decode(Self.self, from: data)
        } catch let decodingError {
            throw API.Error.invalidData(detail: decodingError.localizedDescription)
        }
    }
}

// MARK: - Extract Response String
extension OpenAIResponse {
    var aiResponseText: String {
        (self.choices?.first?.message?.content).orEmpty
    }
}

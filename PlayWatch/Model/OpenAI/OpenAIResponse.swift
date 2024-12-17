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
    static func decode(from data: Data) throws -> String {
        do {
            let model = try JSONDecoder().decode(Self.self, from: data)
            return (model.choices?.first?.message?.content).orEmpty
        } catch let decodingError {
            throw API.Error.invalidData(detail: decodingError.localizedDescription)
        }
    }
}

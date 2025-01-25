//
//  GeminiBody.swift
//  PlayWatch
//
//  Created by David on 25/1/25.
//

import Foundation

struct GeminiBody {
    struct Body: Codable {
        let contents: Content
    }
    struct Content: Codable {
        let parts: Part
    }
    struct Part: Codable {
        let text: String
    }
}

// MARK: - Encoding
extension GeminiBody {
    static func encode(movies: String, language: String, using encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        let prompt = Constants.quizPrompt(movies, language)
        do {
            return try encoder.encode(Body(contents: Content(parts: Part(text: prompt))))
        } catch let decodingError {
            throw API.Error.invalidData(detail: decodingError.localizedDescription)
        }
    }
}

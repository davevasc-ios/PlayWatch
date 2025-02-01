//
//  OpenAIBody.swift
//  PlayWatch
//
//  Created by David on 25/1/25.
//

import Foundation

struct OpenAIBody {
    
    struct Body: Codable {
        let model: String
        let messages: [Message]
    }
    struct Message: Codable {
        let role: Role
        let content: String
    }
    enum Role: String, Codable {
        case system, user
    }
    
    enum SystemContent: String {
        case json = "You are an assistant that only generates a valid JSON files. You will always return only a valid JSON file, don’t write nothing outside from JSON file.",
             translator = "You are an assistant that only translate one text in other. You will always return only a valid translated text, don’t write nothing outside from a valid translation text."
    }
    
    enum UserPrompt: CustomStringConvertible {
        case quiz(String, String),
             text(String)
        
        var description: String {
            switch self {
            case .quiz(let movies, let language):
                return Constants.quizPrompt(movies, language)
            case .text(let text):
                return text
            }
        }
    }
}

// MARK: - Encoding
extension OpenAIBody {
    static func encode(model: String, movies: String, language: String, using encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        let prompt = UserPrompt.quiz(movies, language)
        let system = Message(role: .system, content: SystemContent.json.rawValue)
        let user = Message(role: .user, content: prompt.description)
        do {
            return try encoder.encode(Body(model: model, messages: [system, user]))
        } catch let decodingError {
            throw API.Error.invalidData(detail: decodingError.localizedDescription)
        }
    }
}

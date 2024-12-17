//
//  GeminiResponse.swift
//  PlayWatch
//
//  Created by David on 7/4/24.
//

import Foundation

struct GeminiResponse: Codable {
  let candidates: [Candidate]?
}

struct Candidate: Codable {
  let content: Content?
}

struct Content: Codable {
  let parts: [Part]?
}

struct Part: Codable {
  let text: String?
}

// MARK: - Decoding
extension GeminiResponse {
    static func decode(from data: Data) throws -> String {
        do {
            let model = try JSONDecoder().decode(Self.self, from: data)
            return (model.candidates?.first?.content?.parts?.first?.text).orEmpty
        } catch let decodingError {
            throw API.Error.invalidData(detail: decodingError.localizedDescription)
        }
    }
}

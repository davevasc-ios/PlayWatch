//
//  GeminiModel.swift
//  PlayWatch
//
//  Created by David on 7/4/24.
//

import Foundation

struct GeminiModel: Codable {
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

extension GeminiModel {
    static func decode(from data: Data) throws -> String {
        let model = try JSONDecoder().decode(Self.self, from: data)
        return (model.candidates?.first?.content?.parts?.first?.text).orEmpty
    }
}

//
//  OpenAIModel.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

import Foundation

struct OpenAIModel: Codable {
    let choices: [Choice]?
}

struct Choice: Codable {
    let message: Response?
}

struct Response: Codable {
    let content: String?
}

extension OpenAIModel {
    static func decode(from data: Data) throws -> String {
        let model = try JSONDecoder().decode(Self.self, from: data)
        return (model.choices?.first?.message?.content).orEmpty
    }
}

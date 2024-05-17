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

struct Quiz: Codable, Hashable {
    let question: String?
    let result: Bool?
}

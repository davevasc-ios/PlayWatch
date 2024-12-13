//
//  GameModel.swift
//  PlayWatch
//
//  Created by David on 16/5/24.
//

import Foundation

struct Quiz: Codable, Hashable {
    let question: String?
    let result: Bool?
}

struct GameQuiz: Identifiable, Equatable {
    let id = UUID()
    let movie: Media
    let quiz: Quiz
    
    static func == (lhs: GameQuiz, rhs: GameQuiz) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Quiz {
    static func decode(from data: Data) throws -> [Self] {
        return try JSONDecoder().decode([Self].self, from: data)
    }
}

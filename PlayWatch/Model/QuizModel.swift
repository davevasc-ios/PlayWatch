//QuizModel.swift
//  PlayWatch
//
//  Created by David on 16/5/24.
//

import Foundation

struct QuizModel: Codable, Hashable {
    let question: String?
    let result: Bool?
}

struct GameQuiz: Identifiable, Equatable {
    let id = UUID()
    let movie: Media
    let quiz: QuizModel
    
    static func == (lhs: GameQuiz, rhs: GameQuiz) -> Bool {
        return lhs.id == rhs.id
    }
}

extension QuizModel {
    static func decode(from data: Data) throws -> [Self] {
        do {
            return try JSONDecoder().decode([Self].self, from: data)
        } catch {
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
}

//
//  GameModel.swift
//  PlayWatch
//
//  Created by David on 16/5/24.
//

import Foundation

struct GameQuiz: Identifiable, Equatable {
    let id = UUID()
    let movie: Media
    let quiz: Quiz
    
    static func == (lhs: GameQuiz, rhs: GameQuiz) -> Bool {
        return lhs.id == rhs.id
    }
}

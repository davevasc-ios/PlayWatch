//
//  GameQuiz.swift
//  PlayWatch
//
//  Created by David on 17/12/24.
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

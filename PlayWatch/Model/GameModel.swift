//
//  GameModel.swift
//  PlayWatch
//
//  Created by David on 16/5/24.
//

import Foundation

struct GameQuiz: Identifiable {
    let id = UUID()
    let movie: Media
    let quiz: Quiz
}

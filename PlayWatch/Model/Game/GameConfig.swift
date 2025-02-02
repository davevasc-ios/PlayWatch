//
//  GameConfig.swift
//  PlayWatch
//
//  Created by David on 2/2/25.
//

import Foundation

enum GameConfig {
    
    static let screenCutoffScale: CGFloat = 0.8 / 2
    static let questionHeightScale: CGFloat = 0.15
    static let quizWidhtScale: CGFloat = 0.65
    static let quizCardDegrees: CGFloat = 12
    static let typingTextIntervales: [UInt64] = [10000000, 40000000, 80000000, 160000000, 200000000]
    static let swipeDownDegrees: [Double] = [-30, -20, -10, 0, 10, 20, 30]
    static let numberOfQuizzes = 20
    static let secondsPerQuiz = 6
}
